# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  config.mailer_sender = ENV['DEFAULT_NOREPLY_EMAIL']

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 8..128

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.sign_out_all_scopes = false

  config.allow_unconfirmed_access_for = 365.days
  config.secret_key = '1fb270d46357a48b8ec3832497ea97accf7fb8bc338d266b049b02041b62d2ac9249285d99a6cd82acf469ad6ca10f3e30545455523b5fdd32a5e71e3ac0f7df'

  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], provider_ignores_state: true,
                  scope: 'email,manage_pages', info_fields: 'first_name,last_name,email'

  config.omniauth :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']

  config.omniauth :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    {scope: 'https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/plus.login	' }
end

Rails.application.config.to_prepare do
  Devise::Mailer.layout 'mailer'
end
