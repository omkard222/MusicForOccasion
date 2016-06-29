require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BookingCoreProject
  # default rails application config
  class Application < Rails::Application
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/uploaders)
    config.active_job.queue_adapter = :delayed_job
    #config.assets.initialize_on_precompile = false
    if Rails.env.test?
      config.stripe.secret_key = 'test'
      config.stripe.publishable_key = 'test'
    else
      config.stripe.publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
    end

    config.to_prepare do

      #Devise::RegistrationsController.layout "board"

      # Load application's model / class decorators
      Dir.glob(File.join(
        File.dirname(__FILE__), '../app/**/*_decorator*.rb'
      )) do |decorator|
        if Rails.configuration.cache_classes
          require(decorator)
        else
          load(decorator)
        end
      end
    end
  end
end
