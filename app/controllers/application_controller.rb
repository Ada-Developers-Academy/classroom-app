class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead of :exception.
  protect_from_forgery with: :null_session
  helper_method :current_user
  before_action :require_login
  check_authorization

  def current_user
    # HACK: get right of this before turing in enable this for admin permission:
    @user ||= User.find(1)
  end

  # TODO: Fix when you have the login situation sorted
  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def not_found
    { file: Rails.root.join('public', '404.html'), status: 404 }
  end

  def error_as_json(message = "")
    render status: :bad_request, json: { errors: message }
  end

  def find_by_params_id
    self.find_by(id: params[:id])
  end

  private

  rescue_from CanCan::AccessDenied do |ex|
    # If we "accidentally" locked ourselves out, would we have to complete our capstone? 🤔
    puts "You are not authorized to do that."
    flash[:error] = "You are not authorized to do that."
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    puts "you dun broke it!"
    render(status: :bad_request, json: { error: "#{ex}" })
  end
end
