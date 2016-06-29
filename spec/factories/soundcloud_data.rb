FactoryGirl.define do
  factory :soundcloud_datum do
    access_token '1-123456-987654321-abcdef123456'
    refresh_token 'fea68e89b99e3e148c6367dc2acbc00c'
    client_id '123456789'
    token_expires_at 5.minutes.from_now
    association :profile
  end
end
