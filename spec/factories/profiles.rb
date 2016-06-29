require 'faker'
FactoryGirl.define do
  factory :profile do
    transient do
      location_attributes nil
    end

    username { Faker::Name.name }
    stage_name { Faker::Name.name }
    headline Faker::Lorem.sentence
    biography Faker::Lorem.paragraph
    birthday Faker::Date.between(30.years.ago, 18.years.ago)
    profile_picture Faker::Avatar.image
    association :user

    location do
      if location_attributes
        location_name = location_attributes['city'] + ', ' +
                        location_attributes['country']
      else
        location_name = Faker::Address.city + ', ' + Faker::Address.country
      end
      Geocoder::Lookup::Test.add_stub(
        location_name, [
          location_attributes || {
            'latitude'     => Faker::Address.latitude,
            'longitude'    => Faker::Address.longitude,
            'city'         => Faker::Address.city,
            'country'      => Faker::Address.country
          }
        ]
      )
      location_name
    end
    after(:create) do |profile, evaluator|
      create :service, profile: profile
    end
  end
end
