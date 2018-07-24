require 'github_user_info'

class InstructorsController < ApplicationController
  load_and_authorize_resource
  before_action :find_instructor, only: [:show, :update]

  # @return :instructors list of all instructors, regardless of their active status. Sorted by ID.
  def index
    all_instructors = Instructor.all
    render json: { instructors: all_instructors }, status: :ok
  end

  # @param :id
  # @return {'id', 'name', 'github_name', 'active'} if a new instructor is created. Otherwise returns {'error'}.
  def show
    info_as_json
  end

  # @param must contain key :github_name, whose value is is a valid GitHub username
  # @return {'id', 'name', 'github_name', 'active'} if a new instructor is created. Otherwise returns {'error'}.
  def create
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    existing = Instructor.find_by(uid: uid_from_gh)

    if existing
      render json: {ok: false, errors: "Instructor already exists"}, status: :bad_request
      return
    else
      @instructor = Instructor.new(
        name: params[:name] || params[:github_name],
        github_name: params[:github_name],
        uid: uid_from_gh,
        active: true
      )

      if  @instructor.save
        return info_as_json("Instructor #{@instructor.name} created")
      else
        render status: :bad_request, json: { errors: "Instructor not created"}
        return
      end
    end
  end

  def update
    if @instructor.update(instructor_params)
      info_as_json
    else
      render json: {errors: "Instructor not updated"}, status: :bad_request
    end
  end

  private

  def instructor_params
    params.permit(:name, :github_name, :uid, :active, :user_invite)
  end

  def find_instructor
    @instructor = Instructor.find_by(id: params[:id])
  end

  # # QUESTION: can we refactor this out? Most/all controllers use this
  # rescue_from ActiveRecord::RecordNotFound do |ex|
  #   render(status: :bad_request,
  #          json: { error: "#{ex}" }
  #   )
  # end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @instructor.as_json(only: [:id, :name, :github_name, :active]),
        message: message
    )
  end

end
