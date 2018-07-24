require 'github_user_info'

class StudentsController < ApplicationController
  load_and_authorize_resource # QUESTION: what does this actually do?
  before_action :find_student, only: [:show, :update, :destroy]

  def index
    data = Student.all
    render status: :ok, json: data
  end

  # :name, :classroom_id, :preferred_name, :github_name, :email, :active
  # TODO: Clean this ugly ass method up
  # TODO: Actually learn how to write throws errors comments in non-Java. It's been 6 months. It's time.
  # @param :name student's full name. If not provided, set to :github_name
  # @param :github_name *REQUIRED* must be a valid GitHub username. Otherwise throws error
  def create
    # TODO: Test!!!
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    return error_as_json("Could not find GitHub username#{params[:github_name]}") if uid_from_gh.nil?

    # TODO: DRY this up with repeated code in user_invites_controller
    # TODO: Add this validation to model
    # TODO: Test!!!
    classroom = Classroom.find_by(id: params[:classroom_id])
    return error_as_json("Could not find classroom with ID #{params[:classroom_id]}") if !classroom.present?

    # TODO: Add index for this then find_by it instead.
    # TODO: Make it so that it looks at cohort, not classroom.
    # TODO: Test!!!
    existing = Student.find_by(classroom_id: params[:classroom_id], uid: uid_from_gh)
    return error_as_json("Student ##{existing.id} for classroom ##{params[:classroom_id]} already exists") if existing


    # TODO: Should we just allow preferred_name to be null instead of forcing it be be something?
    @student = Student.new(
        name: params[:name] || params[:github_name], # must have a github_name
        classroom_id: params[:classroom_id],
        github_name: params[:github_name],
        email: params[:email],
        preferred_name: params[:preferred_name] || params[:name] || params[:github_name],
        uid: uid_from_gh
    )
    @student.save ? info_as_json("Created student #{@student.name}") : error_as_json(@student.errors)
  end

  def update
    @student.update(student_params) ? info_as_json("Updated student #{@student.name}") : error_as_json(@student.errors)
  end

  def show
    info_as_json
  end

  def destroy
    # System.out.println("foo");
    # NotImplementedError
    @student.destroy
    render status: :ok, json: {message: "Student destroyed"}
  end

  private

  def find_student
    @student = Student.find_by(id: params[:id])
  end

  def student_params
   params.permit(:name, :classroom_id, :preferred_name, :github_name, :email, :active)
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @student.as_json(only: [:id, :name, :classroom_id, :preferred_name, :github_name, :active, :email]),
        message: message
    )
  end
end
