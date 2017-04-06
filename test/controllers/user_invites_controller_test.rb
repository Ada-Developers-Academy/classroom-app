require 'test_helper'

class UserInvitesControllerTest < ActionController::TestCase
  class Unauthenticated < UserInvitesControllerTest
    ACTIONS = {
      index: :get,
      new: :get,
      create: :get
    }

    ACTIONS.each do |action, method|
      test "#{action} responds with redirect to root" do
        send(method, action)

        assert_response :redirect
        assert_redirected_to root_path
      end
    end
  end

  class Authenticated < UserInvitesControllerTest
    setup do
      session[:user_id] = users(:instructor).id
    end

    class Index < Authenticated
      test 'responds with success' do
        get :index

        assert_response :ok
      end

      test 'renders appropriate template' do
        get :index

        assert_template 'index'
      end
    end

    class New < Authenticated
      test 'responds with success' do
        get :new

        assert_response :ok
      end

      test 'renders appropriate template' do
        # Initial page with options for student/instructor
        get :new

        assert_template 'new'

        # Student form
        get :new, role: 'student'

        assert_template 'new_student'

        # Instructor form
        get :new, role: 'instructor'

        assert_template 'new_instructor'
      end

      test 'responds 404 with invalid role' do
        get :new, role: 'unknown'

        assert_response :not_found
      end
    end

    class Create < Authenticated
      class Unknown < Create
        test 'responds 404 with invalid role' do
          post :create, role: 'unknown'

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
            cohort_id: cohorts(:sharks)
          }
        end

        test 'redirects to invites index' do
          post :create, create_params

          assert_response :redirect
          assert_redirected_to user_invites_path
        end

        test 'lists invited users and errors in flash notice' do
          post :create, create_params

          assert_equal github_names.length, (flash[:notice].length + flash[:alert].length),
            'Flash messages must have a number of entries that matches the number of GitHub names submitted'
        end

        test 'creates invites for each GitHub name' do
          assert_difference(lambda{ UserInvite.count }, github_names.length) do
            post :create, create_params
          end
        end

        test 'creates invites with student role' do
          assert_difference(lambda{ UserInvite.where(role: 'student').count }, github_names.length) do
            post :create, create_params
          end
        end

        test 'does not create duplicate invites' do
          user_invites(:valid_student).dup.update(github_name: 'adatest1')

          assert_difference(lambda{ UserInvite.count }, github_names.length - 1) do
            post :create, create_params

            assert_equal github_names.length, (flash[:notice].length + flash[:alert].length)
              'Flash messages must have a number of entries that matches the number of GitHub names submitted'
          end
        end

        test 'does not create invites for non-existent cohort' do
          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, create_params.merge(cohort_id: -1)

            refute_nil flash[:alert]
          end
        end

        test 'ignores duplicate names' do
          assert_difference(lambda{ UserInvite.count }, github_names.length) do
            post :create, create_params.merge({
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
          post :create, create_params

          assert_response :redirect
          assert_redirected_to user_invites_path
        end

        test 're-renders form on failure' do
          # I'd like to find a more generic way to force an error
          # when creating the invite
          post :create, create_params.merge(github_name: nil)

          assert_response :ok
          assert_template 'new_instructor'
        end

        test 'creates a new invite' do
          assert_difference(lambda{ UserInvite.count }, 1) do
            post :create, create_params
          end
        end

        test 'creates invite with instructor role' do
          assert_difference(lambda{ UserInvite.where(role: 'instructor').count }, 1) do
            post :create, create_params
          end
        end

        test 'does not create duplicate invites' do
          user_invites(:valid_instructor).dup.update(github_name: github_name)

          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, create_params

            assert_not_nil flash[:alert]
          end
        end

        test 'does not create invites for empty Github username' do
          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, create_params.merge(github_name: '')

            assert_not_nil flash[:alert]
          end

          assert_difference(lambda{ UserInvite.count }, 0) do
            post :create, create_params.merge(github_name: nil)

            assert_not_nil flash[:alert]
          end
        end
      end
    end
  end
end
