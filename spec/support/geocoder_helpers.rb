require 'faker'
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => Faker::Address.latitude,
      'longitude'    => Faker::Address.longitude,
      'state'        => Faker::Address.state,
      'country'      => Faker::Address.country
    }
  ]
)
