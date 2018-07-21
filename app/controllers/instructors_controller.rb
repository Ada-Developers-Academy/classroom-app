require 'github_user_info'

class InstructorsController < ApplicationController
  load_and_authorize_resource
  before_action :find_instructor, only: [:show, :edit, :update, :destroy]

  # @return :instructors list of all instructors, regardless of their active status. Sorted by ID.
  def index
    all_instructors = Instructor.all
    render json: { instructors: all_instructors }, status: :ok
  end

  def show
    NotImplementedError
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
        name: params[:name] || params[:github_name], # params[:github_name] should not be null
        github_name: params[:github_name],
        uid: uid_from_gh,
        active: true
      )

      if new_instructor.save
        render json: { name: new_instructor.name }, status: :ok
        return
      else
        render json: {ok: false, errors: "Instructor not created"}, status: :bad_request
        return
      end
    end
  end

  private
    def instructor_params
      params.require(:instructor).permit(:name, :github_name, :uid, :active, :user_invite)
    end

    def find_instructor
      @instructor = Instructor.find_by(params[:id])
    end

end

#
# rental = Rental.new(movie: @movie, customer: @customer, due_date: params[:due_date])
# rental.returned = false
# if rental.save
#   render status: :ok, json: {due_date: rental.due_date}
# else
#   render status: :bad_request, json: { errors: rental.errors.messages }
# end