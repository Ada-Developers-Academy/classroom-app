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
            github_names: github_names.join("\n")
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

        test 'does not create duplicate invites' do
          UserInvite.create!({
            inviter: users(:instructor),
            role: 'student',
            github_name: 'adatest1'
          })

          assert_difference(lambda{ UserInvite.count }, github_names.length - 1) do
            post :create, create_params

            assert_equal github_names.length, (flash[:notice].length + flash[:alert].length)
              'Flash messages must have a number of entries that matches the number of GitHub names submitted'
          end
        end
      end
    end
  end
end
