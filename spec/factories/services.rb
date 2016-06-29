FactoryGirl.define do
  factory :service do
    headline Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    booking_fee Faker::Number.number(3)
    currency 'USD'
    association :profile
  end
end
