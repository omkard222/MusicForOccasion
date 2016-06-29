require 'rails_helper'

describe ServiceType do
  it { should have_one :service }

  it 'should return all service types' do
    types = []
    5.times do |i|
      type = create(:service_type, name: "service #{i}") 
      types << [type.name, type.id]
    end

    all_seriveces = ServiceType.all_service_types
    expect(all_seriveces).to eq(types)

  end
end