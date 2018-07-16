require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  setup do
    @assignment = assignments(:word_guess)
    @classroom = classrooms(:sharks)
  end

  def create_params
    {
      assignment: {
        repo_url: "test"
      }
    }
  end

  def create_params_invalid
    {
      assignment: {
        repo_url: nil
      }
    }
  end

  def update_params
    {
      id: @assignment.id,
      assignment: {
        repo_url: "other_repo_url"
      }
    }
  end

  def update_params_invalid
    update_params.deep_merge(assignment: { repo_url: nil })
  end

  class Functionality < AssignmentsControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    test "index should load list of assignments" do
      get :index

      assert_template :index
      assert_response :success
    end

    test "should get the new form" do
      get :new

      assert_response :success
      assert_template :new
    end

    test "should not create a assignment without required fields" do
      post :create, params: create_params_invalid

      assert_response :bad_request
      assert_template :new
    end

    test "should redirect when created successfully with required fields" do
      post :create, params: create_params

      assert_redirected_to assignments_path
    end

    test "should redirect when attempting to edit assignment that doesn't exist" do
      get :edit, params: { id: 9999 }

      assert_redirected_to assignments_path
    end

    test "should get the edit form" do
      get :edit, params: { id: @assignment.id }

      assert_response :success
      assert_template :edit
    end

    test "should not update a assignment without required fields" do
      patch :update, params: update_params_invalid

      assert_response :bad_request
      assert_template :edit
    end

    test "should redirect when updated successfully" do
      patch :update,params: update_params

      assert_redirected_to assignments_path
    end

    test "delete should add a flash error when assignment not found" do
      delete :destroy, params: { id: 9999 }

      assert_not_empty flash[:error]
      assert_redirected_to assignments_path
    end

    test "delete should redirect to index on success" do
      delete :destroy, params: { id: @assignment.id }

      assert_redirected_to assignments_path
    end

    def with_github_mock(&block)
      github_mock = Minitest::Mock.new
      def github_mock.retrieve_student_info(assignment, classroom)
        Submission.where(assignment: assignment)
      end

      GitHub.stub :new, github_mock, &block
    end

    test "should get the show page for a particular assignment and classroom" do
      with_github_mock do
        get :show, params: { assignment_id: @assignment.id, id: @classroom.id }

        assert_response :success
        assert_template :show
      end
    end

    test "should redirect when classroom ID is invalid" do
      invalid_classroom_id = 0
      # Sanity check
      assert_nil Classroom.find_by(id: invalid_classroom_id)

      get :show, params: { assignment_id: @assignment.id, id: invalid_classroom_id }

      assert_response :redirect
      assert_redirected_to assignments_path
      assert_not_empty flash[:error]
    end
  end

  class Authorization < AssignmentsControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should get index of assignments" do
        get :index

        assert_response :success
      end

      test "should get new assignment form" do
        get :new

        assert_response :success
      end

      test "should create new assignment" do
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to assignments_path
      end

      test "should get edit assignment form" do
        get :edit, params: { id: @assignment.id }

        assert_response :success
      end

      test "should update existing assignment" do
        patch :update, params: update_params

        assert_response :redirect
        assert_redirected_to assignments_path
      end

      test "should destroy existing assignment" do
        delete :destroy, params: { id: @assignment.id }

        assert_redirected_to assignments_path
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test "should not get index of assignments" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new assignment form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit assignment form" do
        get :edit, params: { id: @assignment.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing assignment" do
        patch :update, params: update_params

        assert_not_equal @assignment.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          delete :destroy, params: { id: @assignment.id }

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end
    end

    class Unauthorized < Authorization
      setup do
        session[:user_id] = users(:unknown).id
      end

      test "should not get index of assignments" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new assignment form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit assignment form" do
        get :edit, params: { id: @assignment.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing assignment" do
        patch :update, params: update_params

        assert_not_equal @assignment.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          delete :destroy, params: { id: @assignment.id }

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end
    end

    class Guest < Authorization
      setup do
        session[:user_id] = nil
      end

      test "should not get index of assignments" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new assignment form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit assignment form" do
        get :edit, params: { id: @assignment.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing assignment" do
        patch :update, params: update_params

        assert_not_equal @assignment.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing assignment" do
        assert_no_difference(lambda { Assignment.count }) do
          delete :destroy, params: { id: @assignment.id }

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end
    end
  end
end
