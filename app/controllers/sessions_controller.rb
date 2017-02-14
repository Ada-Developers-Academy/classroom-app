class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :destroy]

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash["uid"]
      @user = User.find_or_create_from_omniauth(auth_hash)
      if @user
        session[:user_id] = @user.id
        session[:token] = auth_hash['credentials'].token
        redirect_to pull_requests_path
      else
        redirect_to root_path, notice: "Failed to save the user"
      end
    else
      redirect_to root_path, notice: "Failed to authenticate"
    end
  end

  def destroy
    session.delete :user_id
    session.delete :token
    redirect_to root_path
  end
end
