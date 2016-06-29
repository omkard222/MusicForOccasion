require 'faker'
FactoryGirl.define do
  factory :billing_address do
    address1 Faker::Address.street_address
    address2 Faker::Address.secondary_address
    post_code Faker::Address.postcode
    city Faker::Address.city
    country Faker::Address.country
    association :user
  end
end
