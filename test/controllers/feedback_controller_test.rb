require 'test_helper'

class FeedbackControllerTest < ActionController::TestCase
  setup do
    @student = students(:jet)
    @assignment = assignments(:farmar)
  end

  def new_params
    {
      assignment_id: @assignment.id,
      student_id: @student.id
    }
  end

  class Functionality < FeedbackControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    test "should get the new form" do
      get :new, params: new_params

      assert_response :success
      assert_template :new
    end
  end

  class Authorization < FeedbackControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should be able to get the new form" do
        get :new, params: new_params

        assert_response :success
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test "should not be able to get the new form" do
        get :new, params: new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Unauthorized < Authorization
      setup do
        session[:user_id] = users(:unknown).id
      end

      test "should not be able to get the new form" do
        get :new, params: new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Guest < Authorization
      setup do
        session[:user_id] = nil
      end

      test "should not be able to get the new form" do
        get :new, params: new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end
  end
end
