require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  class Functionality < SessionsControllerTest
    class Create < Functionality
      def set_auth_mock(provider)
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider].dup
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
