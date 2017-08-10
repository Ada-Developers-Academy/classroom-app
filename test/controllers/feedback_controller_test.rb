require 'test_helper'

class FeedbackControllerTest < ActionController::TestCase
  class Functionality < FeedbackControllerTest
    setup do
      session[:user_id] = users(:instructor).id
      @student = students(:jet)
      @repo = repos(:farmar)
    end

    test "should get the new form" do
      get :new, { repo_id: @repo.id, student_id: @student.id }

      assert_response :success
      assert_template :new
    end
  end
end
