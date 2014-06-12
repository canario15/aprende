require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Aprende
  class Application < Rails::Application
    require 'constants'
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.generators do |g|
      g.fixture_replacement :machinist
    end

    #config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.autoload_paths += [config.root.join("app/presenters")]

    config.assets.precompile += ['application_responsive.css', 'responsive/application.js']

	config.assets.digest_exclusions = ['*.svg']

    I18n.enforce_available_locales = false

  end
end
