require 'test_helper'

class PullRequestsControllerTest < ActionController::TestCase
  class Functionality < PullRequestsControllerTest
    class Home < Functionality
      class Instructor < Home
        setup do
          session[:user_id] = users(:instructor).id
        end

        test "should redirect to pull requests index" do
          get :home

          assert_response :redirect
          assert_redirected_to pull_requests_path
        end
      end

      class Student < Home
        setup do
          session[:user_id] = users(:student).id
        end

        test "should display the home view" do
          get :home

          assert_response :success
          assert_template :home
        end
      end

      class Unauthorized < Home
        setup do
          session[:user_id] = users(:unknown).id
        end

        test "should display the home view" do
          get :home

          assert_response :success
          assert_template :home
        end
      end

      class Guest < Home
        setup do
          session[:user_id] = nil
        end

        test "should display the home view" do
          get :home

          assert_response :success
          assert_template :home
        end
      end
    end
  end

  class Authorization < PullRequestsControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should get index of pull requests" do
        get :index

        assert_response :success
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test "should not get index of pull requests" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Unauthorized < Authorization
      setup do
        session[:user_id] = users(:unknown).id
      end

      test "should not get index of pull requests" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Guest < Authorization
      setup do
        session[:user_id] = nil
      end

      test "should not get index of pull requests" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end
  end
end
