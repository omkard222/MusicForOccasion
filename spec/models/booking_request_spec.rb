require 'rails_helper'

describe BookingRequest do
  it { should belong_to :profile }
  it { should belong_to :service_proposer }
  it { should belong_to :updated_by }
  it { should belong_to :service }
  it { should validate_presence_of :date }
  it { should validate_presence_of :event_location }
  it do
    should validate_inclusion_of(:status)
    .in_array %w(Pending Accepted Rejected Cancelled Special\ Offer Expired)
  end
  let(:list) { create_list(:booking_request, 4) }

  context 'scopes' do
    it '.duplicated' do
      BookingRequest.update_all(service_id: list[0].service_id)
      list[1].update(status: 'Accepted')
      list[2].update(status: 'Rejected')
      expect(BookingRequest.duplicated(list[0].service_id).pluck(:id).sort)
      .to eq([list[0], list[1], list[3]].map(&:id))
    end

    it '.sum_confirmed_price' do
      i = -1
      default_currency = ENV['ADMIN_DEFAULT_CURRENCY'].downcase
      result = %w(AED ANG RUB IEP).inject(0.0) do |sum, cur|
        i += 1
        list[i].update(currency: cur)
        conversion = "#{list[i].currency.downcase}_to_#{default_currency}"

        stub_request(:get, "http://www.google.com/finance/converter?a=#{list[i].confirmed_price}&from=#{list[i].currency}&to=#{ENV['ADMIN_DEFAULT_CURRENCY']}").
         to_return(:status => 200, :body => "<span class=bld>#{list[i].confirmed_price}")
        sum + GoogCurrency.send(conversion, list[i].confirmed_price)
      end
      .round(2)

      stub_request(:get, "http://www.google.com/finance/converter?a=#{list.first.confirmed_price}&from=USD&to=USD").
         to_return(:status => 200, :body => "<span class=bld>#{list[i].confirmed_price}")

      expect(BookingRequest.sum_confirmed_price).to eq(result)
    end

  end

  it '.update_expired' do
    list.each { |booking| booking.update(date: 1.month.from_now) }
    list[1].update(date: 15.days.from_now)
    Timecop.travel(18.day.from_now)
    BookingRequest.update_expired
    expect(BookingRequest.where(status: 'Expired').pluck(:id))
    .to eq [list[1].id]
  end

  it 'reject date that is past' do
    booking = BookingRequest.new(date: 1.day.ago)
    expect(booking.save).to eq(false)
  end

  context 'instance methods' do
    let(:booking_request) { build(:booking_request) }
    it '#special_offer?' do
      booking_request.special_price = 232
      expect(booking_request.special_offer?).to eq(booking_request.special_price)
    end

    it '#status_enum' do
      expect(booking_request.status_enum)
      .to eq([['Pending'], ['Accepted'], ['Rejected'], ['Cancelled'], ['Special Offer']])
    end

    it '#service_deleted?' do
      expect(booking_request.service_deleted?).to be false
      booking_request.service.deleted_at = Time.zone.now
      expect(booking_request.service_deleted?).to be true
    end
  end

  context 'validations' do

    let(:request) { build(:booking_request) }
    let(:count) { BookingRequest.count }

    it 'checks validations of currency' do
      request.currency = nil
      expect { request.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(BookingRequest.count).to eq(count)
      request.currency = 'ABC'
      expect { request.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(BookingRequest.count).to eq(count)
      request.currency = 'USD'
      expect { request.save! }.to_not raise_error(ActiveRecord::RecordInvalid)
      expect(BookingRequest.count).to eq(count + 1)
    end

  end

end
