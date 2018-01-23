class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :destroy]
  skip_authorization_check only: [:create, :destroy]

  def create
    auth_hash = request.env['omniauth.auth']

    if params[:provider] != "schoology"
      # github 
      if auth_hash && auth_hash["uid"]
        @user = User.update_or_create_from_omniauth(auth_hash)
        if @user
          session[:user_id] = @user.id
          session[:token] = auth_hash['credentials'].token

          # If they've been invited, accept it automatically
          github_name = auth_hash["extra"]["raw_info"]["login"]
          invite = UserInvite.acceptable.find_by(github_name: github_name)
          if invite
            begin
              @user.accept_invite(invite)
            rescue
              return redirect_to root_path, notice: "Unable to accept invitation"
            end
          end

          redirect_to root_path
        else
          redirect_to root_path, notice: "Failed to save the user"
        end
      else
        redirect_to root_path, notice: "Failed to authenticate"
      end
    else
      # schoology
    end
  end

  def destroy
    session.delete :user_id
    session.delete :token
    redirect_to root_path
  end

  def github_auth

  end

  def schoology_auth
  end
end
