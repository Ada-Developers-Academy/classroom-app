require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  setup do
    @student = students(:shark)
  end

  def create_params
    {
      student: {
        name: "test",
        github_name: "test_github",
        email: "test@example.com",
        cohort_id: cohorts(:jets).id
      }
    }
  end

  def create_params_invalid
    create_params.deep_merge(student: { github_name: nil, email: nil, cohort_id: nil })
  end

  def create_batch_params
    { students_csv: fixture_file_upload('files/students_good.csv', 'text/csv') }
  end

  def create_batch_params_invalid
    { students_csv: fixture_file_upload('files/students_malformed.csv', 'text/csv') }
  end

  def create_batch_params_new_cohort
    { students_csv: fixture_file_upload('files/students_good_new_cohort.csv', 'text/csv') }
  end

  def update_params
    {
      id: @student.id,
      student: {
        github_name: "othername"
      }
    }
  end

  def update_params_invalid
    update_params.deep_merge(student: { github_name: nil })
  end

  class Functionality < StudentsControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    test "should get the new form" do
      get :new

      assert_response :success
      assert_template :new
    end

    test "should not create a student without required fields" do
      post :create, create_params_invalid

      assert_response :bad_request
      assert_template :new
    end

    test "should redirect when created successfully with required fields" do
      post :create, create_params

      assert_redirected_to students_path
    end

    test "should not create students without a valid CSV" do
      post :create_batch, create_batch_params_invalid

      assert_response :bad_request
      assert_template :new
    end

    test "should redirect when students are created successfully from CSV" do
      post :create_batch, create_batch_params

      assert_redirected_to students_path
    end

    test "should redirect and create a new cohort when students are created successfully from CSV" do

      student_count = Student.count
      cohort_count = Cohort.count


      post :create_batch, create_batch_params_new_cohort

      assert_operator Student.count, :>, student_count

      assert_operator Cohort.count, :>, cohort_count

      assert_redirected_to students_path
    end

    test "should redirect when attempting to edit student that doesn't exist" do
      get :edit, { id: 9999 }

      assert_redirected_to students_path
    end

    test "should get the edit form" do
      get :edit, { id: @student.id }

      assert_response :success
      assert_template :edit
    end

    test "should not update a student without required fields" do
      patch :update, update_params_invalid

      assert_response :bad_request
      assert_template :edit
    end

    test "should redirect when updated successfully" do
      patch :update, update_params

      assert_redirected_to students_path
    end

    test "show should redirect to index when student not found" do
      get :show, { id: 9999 }

      assert_not_empty flash[:error]
      assert_redirected_to students_path
    end

    test "should load show template for an individual student" do
      get :show, { id: @student.id }

      assert_response :success
      assert_template :show
    end

    test "delete should add a flash error when student not found" do
      delete :destroy, { id: 9999 }

      assert_not_empty flash[:error]
      assert_redirected_to students_path
    end

    test "delete should redirect to index on success" do
      delete :destroy, { id: @student.id }

      assert_redirected_to students_path
    end

    test "index should load list of students" do
      get :index

      assert_template :index
      assert_response :success
    end
  end

  class Authorization < StudentsControllerTest
    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      test "should get index of students" do
        get :index

        assert_response :success
      end

      test "should get show page of student" do
        get :show, id: @student.id

        assert_response :success
      end

      test "should get new student form" do
        get :new

        assert_response :success
      end

      test "should create new student" do
        post :create, create_params

        assert_response :redirect
        assert_redirected_to students_path
      end

      test "should batch create new students" do
        post :create_batch, create_batch_params

        assert_response :redirect
        assert_redirected_to students_path
      end

      test "should get edit student form" do
        get :edit, id: @student.id

        assert_response :success
      end

      test "should update existing student" do
        patch :update, update_params

        assert_response :redirect
        assert_redirected_to students_path
      end

      test "should destroy existing student" do
        delete :destroy, id: @student.id

        assert_redirected_to students_path
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student_shark).id
      end

      test "should get index of students" do
        get :index

        assert_response :success
        assert_template :index
      end

      test "should get show page of own student" do
        get :show, id: @student.id

        assert_response :success
        assert_template :show
      end

      test "should not get show page of other student" do
        student = students(:jet)
        get :show, id: student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new student form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new student" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create, create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not batch create new students" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create_batch, create_batch_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit student form" do
        get :edit, id: @student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing student" do
        patch :update, update_params

        assert_not_equal @student.reload.github_name, "othername"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing student" do
        assert_no_difference(lambda { ::Student.count }) do
          delete :destroy, id: @student.id

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

      test "should not get index of students" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get show page of student" do
        get :show, id: @student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new student form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new student" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create, create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not batch create new students" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create_batch, create_batch_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit student form" do
        get :edit, id: @student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing student" do
        patch :update, update_params

        assert_not_equal @student.reload.github_name, "othername"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing student" do
        assert_no_difference(lambda { ::Student.count }) do
          delete :destroy, id: @student.id

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

      test "should not get index of students" do
        get :index

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get show page of student" do
        get :show, id: @student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not get new student form" do
        get :new

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not create new student" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create, create_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not batch create new students" do
        assert_no_difference(lambda { ::Student.count }) do
          post :create_batch, create_batch_params

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "should not get edit student form" do
        get :edit, id: @student.id

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not update existing student" do
        patch :update, update_params

        assert_not_equal @student.reload.github_name, "othername"
        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end

      test "should not destroy existing student" do
        assert_no_difference(lambda { ::Student.count }) do
          delete :destroy, id: @student.id

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end
    end
  end
end
