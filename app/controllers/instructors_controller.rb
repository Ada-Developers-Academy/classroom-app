require 'github_user_info'

class InstructorsController < ApplicationController
  load_and_authorize_resource
  before_action :find_instructor, only: [:show, :edit, :update, :destroy]

  # @return :instructors list of all instructors, regardless of their active status. Sorted by ID.
  def index
    all_instructors = Instructor.all
    render json: { instructors: all_instructors }, status: :ok
  end

  # @param :id
  # @return {'id', 'name', 'github_name', 'active'} if a new instructor is created. Otherwise returns {'error'}.
  def show
    return info_as_json
  end

  def edit
    # instructor = Instructor.find_by(params[:id])
  end

  def update

    if @instructor.update(instructor_params)
      return info_as_json
      # render json: { name: new_instructor.name }, status: :ok
    else
      render json: {ok: false, errors: "Instructor not created"}, status: :bad_request
    end
    #
    # if instructor.save
    #   render json: { name: new_instructor.name }, status: :ok
    #   return
    # else
    #   render json: {ok: false, errors: "Instructor not created"}, status: :bad_request
    #   return
    # end
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
        return info_as_json
      else
        render status: :bad_request, json: { errors: "Instructor not created"}
        return
      end
    end
  end

  private

  def info_as_json
    return render(
        status: :ok,
        json: @instructor.as_json(only: [:id, :name, :github_name, :active])
    )
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    render(status: :bad_request,
           json: { error: "#{ex}" }
    )
  end

  def instructor_params
    params.permit(:name, :github_name, :uid, :active, :user_invite)
  end

  def find_instructor
    @instructor = Instructor.find_by(id: params[:id])
  end

end
