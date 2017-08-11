require 'test_helper'

class FeedbackControllerTest < ActionController::TestCase
  setup do
    @student = students(:jet)
    @repo = repos(:farmar)
  end

  def new_params
    {
      repo_id: @repo.id,
      student_id: @student.id
    }
  end

  def create_params
    new_params.merge({
      Feedback: "This is feedback for a project submission, used in our unit tests."
    })
  end

  class Functionality < FeedbackControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    def feedback_url
      "https://github.com/Ada-test/PR-App-test-individual/pull/1/#issue-1234567890"
    end

    def api_mock
      Minitest::Mock.new.expect(:add_new, feedback_url, [String, String, String])
    end

    class New < Functionality
      test "should get the new form" do
        get :new, new_params

        assert_response :success
        assert_template :new
      end
    end

    class Create < Functionality
      test "should redirect to repo show page" do
        GitHubComment.stub :new, api_mock do
          post :create, create_params

          assert_response :redirect
          assert_redirected_to repo_cohort_path(@repo, @student.cohort)
        end
      end

      test "should save the feedback comment URL for all grouped submissions" do
        GitHubComment.stub :new, api_mock do
          post :create, create_params

          Submission.grouped_with(@student.submission_for_repo(@repo)).each do |sub|
            assert sub.feedback_url = feedback_url
          end
        end
      end
    end
  end

  class Authorization < FeedbackControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should be able to get the new form" do
        get :new, new_params

        assert_response :success
      end

      test "should be able to create feedback" do
        post :create, create_params

        assert_response :redirect
        assert_redirected_to repo_cohort_path(@repo, @student.cohort)
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test "should not be able to get the new form" do
        get :new, new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not be able to create feedback" do
        post :create, create_params

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
        get :new, new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not be able to create feedback" do
        post :create, create_params

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
        get :new, new_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not be able to create feedback" do
        post :create, create_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end
  end
end
