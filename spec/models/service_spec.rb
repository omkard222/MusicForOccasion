require 'rails_helper'

describe Service do
  it { should respond_to :headline }
  it { should respond_to :description }
  it { should respond_to :booking_fee  }
  it { should respond_to :currency }
  it { should belong_to :profile }

  it 'has an alias for name' do
    profile = create :profile
    service = create :service, profile: profile
    expect(service.name).to eq(service.headline)
  end

  it 'should return services of surrounding users' do
    profile_uk = create :profile,
                     location_attributes: { 'latitude'     => 51.5073509,
                                            'longitude'    => -0.1277583,
                                            'city'        => 'London',
                                            'country'      => 'UK'
                                          }

    profile_my = create :profile,
                     location_attributes: { 'latitude'     => 3.139003,
                                            'longitude'    => 101.686855,
                                            'city'         => 'Kuala Lumpur',
                                            'country'      => 'Malaysia'
                                          }
    service_my = profile_my.services.last
    service_uk = profile_uk.services.last

    returned_service = Service.near(profile_my.location)
    expect(returned_service[0]).to eq(service_my)
    expect(returned_service[0]).not_to eq(service_uk)
  end

  context 'validations' do

    let(:service) { build(:service, booking_fee_type: 2, fee_time_type: 1) }
    let(:count) { Service.count }

    it 'checks validations of currency' do
      service.currency = nil
      expect { service.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Service.count).to eq(count)
      service.currency = 'ABC'
      expect { service.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Service.count).to eq(count)
      service.currency = 'USD'
      expect { service.save! }.to_not raise_error(ActiveRecord::RecordInvalid)
      expect(Service.count).to eq(count + 1)
    end

    it 'checks validations of minutes_count' do
      service.update(fee_time_type: 0)
      service.minutes_count = nil
      expect { service.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Service.count).to eq(count)
      service.minutes_count = 100
      expect { service.save! }.to_not raise_error(ActiveRecord::RecordInvalid)
      expect(Service.count).to eq(count + 1)
    end

  end

end
