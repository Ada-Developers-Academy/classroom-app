require 'test_helper'

class ReposControllerTest < ActionController::TestCase
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
    post :create, { repo: { repo_url: nil }}

    assert_response :bad_request
    assert_template :new
  end

  test "should redirect when created successfully with required fields" do
    post :create, { repo: { repo_url: "test" }}

    assert_redirected_to repos_path
  end
end
