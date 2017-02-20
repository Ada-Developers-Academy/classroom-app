require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = users(:instructor).id
    @student = students(:shark)
  end

  test "should get the new form" do
    get :new

    assert_response :success
    assert_template :new
  end

  test "should not create a student without required fields" do
    post :create, { student: { name: "test" }}

    assert_response :bad_request
    assert_template :new
  end

  test "should redirect when created successfully with required fields" do
    post :create, { student: { name: "test", github_name: "test_github",
      email: "test@github.com", cohort_id: Cohort.first.id }}

    assert_redirected_to students_path
  end

  test "should get the edit form" do
    get :edit, { id: @student.id }

    assert_response :success
    assert_template :edit
  end

  test "should not update a student without required fields" do
    patch :update, { id: @student.id , student: { name: nil }}

    assert_response :bad_request
    assert_template :edit
  end

  test "should redirect when updated successfully" do
    patch :update, { id: @student.id, student: { github_name: "othername" }}

    assert_redirected_to students_path
  end
end
