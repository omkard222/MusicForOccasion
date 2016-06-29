FactoryGirl.define do
  factory :booking_request do
    date Faker::Time.forward(23, :morning)
    event_location 'anywhere'
    status 'Pending'
    currency 'USD'
    confirmed_price Faker::Number.number(3)
    association :profile
    association :service
    association :service_proposer, factory: :profile
  end
end
