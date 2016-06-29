# Model for BookingRequest
class BookingRequest < ActiveRecord::Base

  POSSIBLE_CURRENCIES = %w(AED ARS AUD BGN BRL CAD CHF CNY CRC CZK
                           DKK EUR GBP HKD HRK HUF HUF ILS INR JPY
                           KRW MAD MXN MYR NOK NZD PEN PHP PLN RON
                           RUB SEK SGD THB THB TWD UAH USD VND ZAR)

  acts_as_paranoid
  belongs_to :profile
  belongs_to :service_proposer, class_name: 'Profile', foreign_key: 'service_proposer_id'
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'
  belongs_to :service
  validates :date, presence: true
  validates :event_location, presence: true
  validates_datetime :date, after: (lambda do
    Time.now.strftime('%Y/%m/%d %H:%M')
  end), on: :create
  default_scope { order('updated_at DESC') }
  statuses = %w(Pending Accepted Rejected Cancelled Special\ Offer Expired)
  validates_inclusion_of :status, in: statuses
  validates :currency, inclusion: { in: POSSIBLE_CURRENCIES }

  scope :duplicated, (lambda do |service_id|
    where("(service_id = #{ service_id }) AND
      (status = 'Pending' OR status = 'Accepted')")
  end)

  scope :sum_confirmed_price, (lambda do
    all.inject(0.0) do |sum, booking|
      default_currency = ENV['ADMIN_DEFAULT_CURRENCY'].downcase
      conversion = "#{booking.currency.downcase}_to_#{default_currency}"
     
        begin
          sum + GoogCurrency.send(conversion, booking.confirmed_price)
        rescue
          if booking.confirmed_price.nil?
            sum + 0.0
          else
            sum + booking.confirmed_price
          end
      end  
    end
    .round(2)
  end)

  scope :booking_list, (lambda do |current_profile_id|
    where(service_proposer_id: current_profile_id)
  end)

  scope :request_list, (lambda do |current_profile_id|
    where(profile_id: current_profile_id)
  end)

  def self.update_expired
    where('date < ? AND status <> ?', Date.today, 'Cancelled')
    .update_all(status: 'Expired')
  end

  def special_offer?
    special_price
  end

  def status_enum
    [['Pending'], ['Accepted'], ['Rejected'], ['Cancelled'], ['Special Offer']]
  end

  def service_deleted?
    service.deleted_at.present?
  end

end
