require 'test_helper'

class ReposControllerTest < ActionController::TestCase
  class Functionality < ReposControllerTest
    setup do
      session[:user_id] = users(:instructor).id
      @repo = repos(:word_guess)
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
      post :create, { repo: { repo_url: nil }}

      assert_response :bad_request
      assert_template :new
    end

    test "should redirect when created successfully with required fields" do
      post :create, { repo: { repo_url: "test" }}

      assert_redirected_to repos_path
    end

    test "should redirect when attempting to edit repo that doesn't exist" do
      get :edit, { id: 9999 }

      assert_redirected_to repos_path
    end


    test "should get the edit form" do
      get :edit, { id: @repo.id }

      assert_response :success
      assert_template :edit
    end

    test "should not update a repo without required fields" do
      patch :update, { id: @repo.id , repo: { repo_url: nil }}

      assert_response :bad_request
      assert_template :edit
    end

    test "should redirect when updated successfully" do
      patch :update, { id: @repo.id, repo: { repo_url: "other_repo_url" }}

      assert_redirected_to repos_path
    end

    test "delete should add a flash error when repo not found" do
      delete :destroy, { id: 9999 }

      assert_not_empty flash[:error]
      assert_redirected_to repos_path
    end

    test "delete should redirect to index on success" do
      delete :destroy, { id: @repo.id }

      assert_redirected_to repos_path
    end
  end
end
