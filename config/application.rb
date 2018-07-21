require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PullRequests  # TODO: do we need this?
  class Application < Rails::Application
    # config.api_only = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :options]
      end
    end

    # Added. TODO: Needed?
    # https://github.com/rails/rails/pull/17227
    # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#halting-callback-chains-via-throw-abort
    # ActiveSupport.halt_callback_chains_on_return_false = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # TODO: need? was in original
    #  # Auto-generate .js files instead of .coffee
    # config.generators do |g|
    #   g.javascript_engine :js
    # end
  end
end
