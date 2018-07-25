require 'github_user_info'

class InstructorsController < ApplicationController
  load_and_authorize_resource
  before_action :find_instructor, only: [:show, :update]

  def index
    instructors_data = params[:active] ? Instructor.where(active: params[:active]) : Instructor.all
    render json: instructors_data, status: :ok
  end

  def show
    info_as_json
  end

  # @param must contain key :github_name, whose value is is a valid GitHub username
  # @return {'id', 'name', 'github_name', 'active'} if a new instructor is created. Otherwise returns {'error'}.
  def create
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])

    if Instructor.find_by(uid: uid_from_gh)
      error_as_json("Instructor with that UID from GitHub already exists.")
    else
      @instructor = Instructor.new(
        name: params[:name] || params[:github_name],
        github_name: params[:github_name],
        uid: uid_from_gh,
        active: true
      )
      @instructor.save ? info_as_json("Instructor created") : error_as_json(@instructor.errors)
    end
  end

  def update
    @instructor.update(instructor_params) ? info_as_json("Updated instructor") : error_as_json(@instructor.errors)
  end

  private

  def instructor_params
    params.permit(:name, :github_name, :uid, :active, :user_invite)
  end

  def find_instructor
    @instructor = Instructor.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @instructor.as_json(only: [:id, :name, :uid, :github_name, :active]),
        message: message
    )
  end

end
