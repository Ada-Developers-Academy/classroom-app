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
  # @return :instructor if provided a valid id
  # @return :error if not provided a valid id
  def show
    render(
      status: :ok,
      json: @instructor.as_json(only: [:id, :name, :github_name, :active])
    )
  end

  def edit
    instructor = Instructor.find_by(params[:id])

    if instructor.save
      render json: { name: new_instructor.name }, status: :ok
      return
    else
      render json: {ok: false, errors: "Instructor not created"}, status: :bad_request
      return
    end
  end

  # @param must contain key :username, whose value is is a valid GitHub username
  # @return json that responds to :name if a new instructor is created. Otherwise returns error.
  def create
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    existing = Instructor.find_by(uid: uid_from_gh)

    if existing
      render json: {ok: false, errors: "Instructor already exists"}, status: :bad_request
      return
    else
      new_instructor = Instructor.new(
        name: params[:name] || params[:github_name],
        github_name: params[:github_name],
        uid: uid_from_gh,
        active: true
      )

      if new_instructor.save
        return info_as_json
      else
        render json: {ok: false, errors: "Instructor not created"}, status: :bad_request
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
    render json: { error: "#{ex}" }, status: :bad_request
  end

  def instructor_params
    params.permit(:name, :github_name, :uid, :active, :user_invite)
  end

  def find_instructor
    @instructor = Instructor.find_by(id: params[:id])
  end

end
