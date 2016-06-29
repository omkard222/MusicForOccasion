require 'faker'
FactoryGirl.define do	
  factory :genre do
    name { Faker::Name.name }
  end
end