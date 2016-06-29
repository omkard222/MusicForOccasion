FactoryGirl.define do
  factory :additional_picture do
    image Faker::Avatar.image
    association :profile
  end
end
