FactoryGirl.define do
  factory :review do
    message 'Test review'
    score 	5
    association :profile
  end
end
