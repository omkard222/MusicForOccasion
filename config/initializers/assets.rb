# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.precompile += %w( facebook.js )
Rails.application.config.assets.precompile += %w( stripe_checkout.js )
Rails.application.config.assets.precompile += %w( submenu.js )
Rails.application.config.assets.precompile += %w( admin_reset_user_password.js )
Rails.application.config.assets.precompile += %w( welcome.css )
Rails.application.config.assets.precompile += %w( progress-wizard.min.css )
Rails.application.config.assets.precompile += %w( welcome.css owl.carousel.css owl.theme.css owl.transitions.css )
Rails.application.config.assets.precompile += %w( mailer.css )
Rails.application.config.assets.precompile += %w( i18n.js )
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( application.css )
