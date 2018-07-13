require 'test_helper'

class UserInvitesControllerTest < ActionController::TestCase
  class Functionality < UserInvitesControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    class Index < Functionality
      test 'responds with success' do
        get :index

        assert_response :ok
      end

      test 'renders appropriate template' do
        get :index

        assert_template 'index'
      end
    end

    class NewStudent < Functionality
      test 'responds with success' do
        get :new_student

        assert_response :ok
      end

      test 'renders appropriate template' do
        get :new_student

        assert_template 'new_student'
      end
    end

    class NewInstructor < Functionality
      test 'responds with success' do
        get :new_instructor

        assert_response :ok
      end

      test 'renders appropriate template' do
        get :new_instructor

        assert_template 'new_instructor'
      end
    end

    class Create < Functionality
      class Unknown < Create
        test 'responds 404 with invalid role' do
          post :create, params: { role: 'unknown' }

          assert_response :not_found
        end
      end

      class Student < Create
        def github_names
          %w( adatest1 adatest2 adatest3 )
        end

        def create_params
          {
            role: 'student',
            github_names: github_names.join("\n"),
            classroom_id: classrooms(:sharks)
          }
        end

        test 'redirects to invites index' do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to user_invites_path
        end

        test 'lists invited users and errors in flash notice' do
          post :create, params: create_params

          assert_equal github_names.length, (flash[:notice].length + flash[:alert].length),
            'Flash messages must have a number of entries that matches the number of GitHub names submitted'
        end

        test 'creates invites for each GitHub name' do
          assert_difference(lambda{ UserInvite.count }, github_names.length) do
            post :create, params: create_params
          end
        end

        test 'creates invites with student role' do
          assert_difference(lambda{ UserInvite.where(role: 'student').count }, github_names.length) do
            post :create, params: create_params
          end
        end

        test 'does not create duplicate invites' do
          user_invites(:valid_student).dup.update(github_name: 'adatest1')

          assert_difference(lambda{ UserInvite.count }, github_names.length - 1) do
            post :create, params: create_params

            assert_equal github_names.length, (flash[:notice].length + flash[:alert].length)
              'Flash messages must have a number of entries that matches the number of GitHub names submitted'
          end
        end

        test 'does not create invites for non-existent classroom' do
          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, params: create_params.merge(classroom_id: -1)

            refute_nil flash[:alert]
          end
        end

        test 'ignores duplicate names' do
          assert_difference(lambda{ UserInvite.count }, github_names.length) do
            post :create, params: create_params.merge({
              github_names: (github_names + [github_names.last]).join("\n")
            })
          end
        end
      end

      class Instructor < Create
        def github_name
          'adatest1'
        end

        def create_params
          {
            role: 'instructor',
            github_name: 'adatest1'
          }
        end

        test 'redirects to invites index on success' do
          post :create, params: create_params

          assert_response :redirect
          assert_redirected_to user_invites_path
        end

        test 're-renders form on failure' do
          # I'd like to find a more generic way to force an error
          # when creating the invite
          post :create, params: create_params.merge(github_name: nil)

          assert_response :ok
          assert_template 'new_instructor'
        end

        test 'creates a new invite' do
          assert_difference(lambda{ UserInvite.count }, 1) do
            post :create, params: create_params
          end
        end

        test 'creates invite with instructor role' do
          assert_difference(lambda{ UserInvite.where(role: 'instructor').count }, 1) do
            post :create, params: create_params
          end
        end

        test 'does not create duplicate invites' do
          user_invites(:valid_instructor).dup.update(github_name: github_name)

          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, params: create_params

            assert_not_nil flash[:alert]
          end
        end

        test 'does not create invites for empty Github username' do
          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, params: create_params.merge(github_name: '')

            assert_not_nil flash[:alert]
          end

          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, params: create_params.merge(github_name: nil)

            assert_not_nil flash[:alert]
          end
        end
      end
    end
  end

  class Authorization < UserInvitesControllerTest
    GET_ACTIONS = %w( index new_student new_instructor )

    def create_params
      {
        role: 'instructor',
        github_name: 'adatest1'
      }
    end

    class Instructor < Authorization
      setup do
        session[:user_id] = users(:instructor).id
      end

      GET_ACTIONS.each do |action|
        test "#{action} responds with success" do
          get action

          assert_response :success
        end
      end

      test "create responds with redirect to invites index" do
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to user_invites_path
        assert_not_empty flash[:notice]
      end
    end

    class Student < Authorization
      setup do
        session[:user_id] = users(:student).id
      end

      GET_ACTIONS.each do |action|
        test "#{action} fails with redirect to root" do
          get action

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "create fails with redirect to root" do
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Unauthorized < Authorization
      setup do
        session[:user_id] = users(:unknown).id
      end

      GET_ACTIONS.each do |action|
        test "#{action} fails with redirect to root" do
          get action

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "create fails with redirect to root" do
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end

    class Guest < Authorization
      setup do
        session[:user_id] = nil
      end

      GET_ACTIONS.each do |action|
        test "#{action} fails with redirect to root" do
          get action

          assert_response :redirect
          assert_redirected_to root_path
          assert_not_empty flash[:error]
        end
      end

      test "create fails with redirect to root" do
        post :create, params: create_params

        assert_response :redirect
        assert_redirected_to root_path
        assert_not_empty flash[:error]
      end
    end
  end
end
