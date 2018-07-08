require 'test_helper'

class ReposControllerTest < ActionController::TestCase
  setup do
    @repo = repos(:word_guess)
    @cohort = cohorts(:sharks)
  end

  def create_params
    {
      repo: {
        repo_url: "test"
      }
    }
  end

  def create_params_invalid
    {
      repo: {
        repo_url: nil
      }
    }
  end

  def update_params
    {
      id: @repo.id,
      repo: {
        repo_url: "other_repo_url"
      }
    }
  end

  def update_params_invalid
    update_params.deep_merge(repo: { repo_url: nil })
  end

  class Functionality < ReposControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    test "index should load list of repos" do
      get :index

      assert_template :index
      assert_response :success
    end

    test "should get the new form" do
      get :new

      assert_response :success
      assert_template :new
    end

    test "should not create a repo without required fields" do
      post :create, params: create_params_invalid

      assert_response :bad_request
      assert_template :new
    end

    test "should redirect when created successfully with required fields" do
      post :create, params: create_params

      assert_redirected_to repos_path
    end

    test "should redirect when attempting to edit repo that doesn't exist" do
      get :edit, params: { id: 9999 }

      assert_redirected_to repos_path
    end

    test "should get the edit form" do
      get :edit, params: { id: @repo.id }

      assert_response :success
      assert_template :edit
    end

    test "should not update a repo without required fields" do
      patch :update, params: update_params_invalid

      assert_response :bad_request
      assert_template :edit
    end

    test "should redirect when updated successfully" do
      patch :update,params: update_params

      assert_redirected_to repos_path
    end

    test "delete should add a flash error when repo not found" do
      delete :destroy, params: { id: 9999 }

      assert_not_empty flash[:error]
      assert_redirected_to repos_path
    end

    test "delete should redirect to index on success" do
      delete :destroy, params: { id: @repo.id }

      assert_redirected_to repos_path
    end

    def with_github_mock(&block)
      github_mock = Minitest::Mock.new
      def github_mock.retrieve_student_info(repo, cohort)
        Submission.where(repo: repo)
      end

      GitHub.stub :new, github_mock, &block
    end

    test "should get the show page for a particular repo and cohort" do
      with_github_mock do
        get :show, params: { repo_id: @repo.id, id: @cohort.id }

        assert_response :success
        assert_template :show
      end
    end

    test "should redirect when cohort ID is invalid" do
      invalid_cohort_id = 0
      # Sanity check
      assert_nil Cohort.find_by(id: invalid_cohort_id)

      get :show, params: { repo_id: @repo.id, id: invalid_cohort_id }

      assert_response :redirect
      assert_redirected_to repos_path
      assert_not_empty flash[:error]
    end
  end

  class Authorization < ReposControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should get index of repos" do
        get :index

        assert_response :success
      end

      test "should get new repo form" do
        get :new

        assert_response :success
      end

      test "should create new repo" do
        # puts "fooooooooooooooooooooooooooooo!!!!!!!!"
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to repos_path
      end

      test "should get edit repo form" do
        get :edit, params: { id: @repo.id }

        assert_response :success
      end

      test "should update existing repo" do
        patch :update, params: update_params

        assert_response :redirect
        assert_redirected_to repos_path
      end

      test "should destroy existing repo" do
        delete :destroy, params: { id: @repo.id }

        assert_redirected_to repos_path
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      test "should not get index of repos" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new repo form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new repo" do
        assert_no_difference(lambda { Repo.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit repo form" do
        get :edit, params: { id: @repo.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing repo" do
        patch :update, params: update_params

        assert_not_equal @repo.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing repo" do
        assert_no_difference(lambda { Repo.count }) do
          delete :destroy, params: { id: @repo.id }

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

      test "should not get index of repos" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new repo form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new repo" do
        assert_no_difference(lambda { Repo.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit repo form" do
        get :edit, params: { id: @repo.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing repo" do
        patch :update, params: update_params

        assert_not_equal @repo.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing repo" do
        assert_no_difference(lambda { Repo.count }) do
          delete :destroy, params: { id: @repo.id }

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

      test "should not get index of repos" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new repo form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new repo" do
        assert_no_difference(lambda { Repo.count }) do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit repo form" do
        get :edit, params: { id: @repo.id }

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing repo" do
        patch :update, params: update_params

        assert_not_equal @repo.reload.repo_url, "other_repo_url"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing repo" do
        assert_no_difference(lambda { Repo.count }) do
          delete :destroy, params: { id: @repo.id }

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end
    end
  end
end
