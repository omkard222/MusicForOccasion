FactoryGirl.define do
  factory :bank_account do
    name Faker::Name.name
    acc_number Faker::Number.number(10)
    bank_name Faker::Company.name
    association :user
  end
end
