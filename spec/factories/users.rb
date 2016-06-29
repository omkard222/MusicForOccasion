require 'faker'
FactoryGirl.define do
  factory :user, class: 'User' do
    transient do
      set_confirmed true
    end

    confirmed_at { Time.zone.now if set_confirmed }

    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'

    first_name Faker::Name.name
    last_name Faker::Name.name
    phone_number Faker::PhoneNumber.phone_number
    stripe_token Faker::Lorem.characters(10)
    payment_method 'normal_banking'

    factory :valid_user do
      after(:create) do |user, evaluator|
        create(:profile, stage_name: Faker::Name.name, user: user)
        user.save!
      end
    end
  end
end
