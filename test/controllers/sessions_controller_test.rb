require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  class Functionality < SessionsControllerTest
    class Create < Functionality
      def set_auth_mock(provider)
        mock = OmniAuth.config.mock_auth[provider].dup
        # This is necessary because OmniAuth only allows us to have one mock per provider
        mock['provider'] = OmniAuth.config.mock_auth[:default]['provider']

        request.env['omniauth.auth'] = mock
      end

      setup do
        set_auth_mock :github
      end

      test 'with no OAuth data redirects to root' do
        request.env['omniauth.auth'] = nil

        get :create, provider: :github

        assert_response :redirect
        assert_redirected_to root_path
        refute_nil flash[:notice]
      end

      test 'OAuth login redirects to root' do
        get :create, provider: :github

        assert_response :redirect
        assert_redirected_to root_path
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

      test 'first-time OAuth login sets appropriate fields on User record' do
        get :create, provider: :github

        user = User.last
        auth_hash = request.env['omniauth.auth']
        assert_equal user.uid, auth_hash['uid'].to_s
        assert_equal user.provider, auth_hash['provider']
        assert_equal user.github_name, auth_hash['extra']['raw_info']['login']
        assert_equal user.name, auth_hash['info']['name']
      end

      test 'existing users update info on login' do
        # Simulate an account which was created before storing github_name
        user = users(:unknown)
        user.github_name = nil
        user.save!(validate: false)

        user_info = {
          github_name: user.github_name,
          name: user.name
        }

        set_auth_mock :github_changed_info
        request.env['omniauth.auth']['uid'] = user.uid

        get :create, provider: :github

        user.reload
        user_info.each do |attr, old_value|
          assert_not_equal user.send(attr), old_value, "Expected User##{attr} to not be #{old_value.inspect}"
        end
      end

      test 'uninvited users have unknown role' do
        set_auth_mock :uninvited

        get :create, provider: :github

        assert_equal 'unknown', User.last.role
      end

      test 'invited instructors have role from invite' do
        # This matches up with the `instructor` UserInvite fixture
        set_auth_mock :invited_instructor

        get :create, provider: :github

        assert_equal 'instructor', User.last.role
      end

      test 'invited students have role from invite' do
        # This matches up with the `student` UserInvite fixture
        set_auth_mock :invited_student

        get :create, provider: :github

        assert_equal 'student', User.last.role
      end

      test 'existing users accept invites' do
        get :create, provider: :github

        user = User.last
        # sanity check
        assert_equal 'unknown', user.role

        # Create a new invite by copying from an existing
        # valid invite and making it work for this user
        user_invites(:valid_instructor).dup.update(github_name: 'adatest')

        get :create, provider: :github

        user.reload
        assert_equal user_invites(:valid_instructor).role, user.role
      end
    end
  end

  class Authorization < SessionsControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test 'should be able to log out' do
        delete :destroy

        assert_response :redirect
        assert_redirected_to root_path
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test 'should be able to log out' do
        delete :destroy

        assert_response :redirect
        assert_redirected_to root_path
      end
    end

    class Unauthorized < Authorization
      setup do
        session[:user_id] = users(:unknown).id
      end

      test 'should be able to log out' do
        delete :destroy

        assert_response :redirect
        assert_redirected_to root_path
      end
    end

    class Guest < Authorization
      setup do
        session[:user_id] = nil
      end

      test 'should be able to log out' do
        delete :destroy

        assert_response :redirect
        assert_redirected_to root_path
      end
    end
  end
end
