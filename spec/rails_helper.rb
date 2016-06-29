# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'spec_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'rspec/rails'
require 'shoulda/matchers'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

ENV['DEFAULT_CURRENCY'] = 'MYR'
ENV['ADMIN_DEFAULT_CURRENCY'] = 'USD'
ENV['DEFAULT_LOCATION_RADIUS'] = '2000'
ENV['DEFAULT_NOREPLY_EMAIL'] = 'test@host.com'
ENV['MAILCHIMP_API_KEY'] = 'fake_key-us10'
Devise.setup { |config| config.mailer_sender = ENV['DEFAULT_NOREPLY_EMAIL'] }
OmniAuth.config.test_mode = true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Geocoder.configure(lookup: :test)
WebMock.disable_net_connect!(allow_localhost: true)
Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url('maps.google.com')
  config.allow_url('maps.googleapis.com')
  config.allow_url('fonts.googleapis.com')
  config.allow_url('csi.gstatic.com')
  config.allow_url('connect.facebook.net')
  config.allow_url('www.facebook.com')
  config.allow_url('maxcdn.bootstrapcdn.com')
end


RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do |example|
    unless example.exception.nil?
      page.driver.browser.try(:render, "#{Rails.root}/tmp/capybara/last_broken.png", 1024, 768)
    end
    DatabaseCleaner.clean
    Timecop.return
  end

  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.before(:all) do # mock for mailchimp API
    Excon.defaults[:mock] = true
    # stubs any request to return an empty JSON string
    Excon.stub({}, body: '{}', status: 200)
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test"]) if Rails.env.test?
  end

  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.include CapybaraHelpers, type: :controller

end
