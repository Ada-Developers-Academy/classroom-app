class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :require_login
  check_authorization

  def current_user
    # @user ||= User.find_by(id: session[:user_id])

    # enable this for admin permission:
    @user |= User.find_by(id: 1)
    # dont forget to change it back to line 10 !
   

  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def not_found
    { file: Rails.root.join('public', '404.html'), status: 404 }
  end

  private

  rescue_from CanCan::AccessDenied do |ex|
    flash[:error] = "You are not authorized to do that."
    redirect_to root_path
  end
end
