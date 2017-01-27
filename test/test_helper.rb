ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Use OmniAuth's mock responses
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
    provider: 'github',
    uid: 123456,
    info: {
      name: 'Test User'
    },
    extra: {
      raw_info: {
        login: 'adatest'
      }
    },
    credentials: {
      token: '7ca3303893156b8c45185b61d0fc8ec3153ee33f',
      expires: false
    }
  })
end
