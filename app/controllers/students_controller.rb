require 'github_user_info'

class StudentsController < ApplicationController
  load_and_authorize_resource
  before_action :find_student, only: [:show, :update]

  def index
    students_data = params[:active] ? Student.where(active: params[:active]) : Student.order(:name)
    render status: :ok, json: students_data
  end

  # TODO: Clean this ugly ass method up
  # TODO: Actually learn how to write throws errors comments in non-Java. It's been 6 months. It's time.
  # @param :name student's full name. If not provided, set to :github_name
  # @param :github_name *REQUIRED* must be a valid GitHub username. Otherwise throws error
  def create
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    return error_as_json("Could not find GitHub username#{params[:github_name]}") if uid_from_gh.nil?

    # TODO: DRY this up with repeated code in user_invites_controller
    # TODO: Add this validation to model
    classroom = Classroom.find_by(id: params[:classroom_id])
    return error_as_json("Could not find classroom with ID #{params[:classroom_id]}") if !classroom.present?

    # TODO: Add index for cohort-uid then find_by it instead.
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

  # # TODO: Make route for this
  # def change_active_status
  #   # System.out.println("foo");
  #   NotImplementedError
  #   @student.active = !@student.active
  #   @student.save ? info_as_json("Student #{@student.name} set to #{@student.active}") : error_as_json(@student.errors)
  # end
  #
  # # TODO: Make route for this
  # def deactivate
  #   # System.out.println("foo");
  #   NotImplementedError
  #   @student.active = false
  #   @student.save ? info_as_json("Student #{@student.name} set to inactive") : error_as_json(@student.errors)
  # end
  #
  # # TODO: Make route for this
  # def activate
  #   # System.out.println("foo");
  #   NotImplementedError
  #   @student.active = true
  #   @student.save ? info_as_json("Student #{@student.name} set to active") : error_as_json(@student.errors)
  # end

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
