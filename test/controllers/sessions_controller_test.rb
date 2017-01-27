require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  class Create < SessionsControllerTest
    setup do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github].dup
    end

    test 'with no OAuth data redirects to root' do
      request.env['omniauth.auth'] = nil

      get :create, provider: :github

      assert_response :redirect
      assert_redirected_to root_path
      refute_nil flash[:notice]
    end

    test 'OAuth login redirects to pull requests page' do
      get :create, provider: :github

      assert_response :redirect
      assert_redirected_to pull_requests_path
      assert_nil flash[:notice]
    end

    test 'first-time OAuth login creates a new user' do
      assert_difference(lambda{ User.count }, 1) do
        get :create, provider: :github
      end

      # Additional logins do not create new users
      assert_no_difference(lambda{ User.count }) do
        get :create, provider: :github
      end
    end
  end
end
