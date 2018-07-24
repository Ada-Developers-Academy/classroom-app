class ClassroomsController < ApplicationController
  load_and_authorize_resource
  before_action :find_classroom, only: [:create, :show, :update]

  def index
    data = Classroom.all
    # TODO: would like to change to this:
    # render json: { classrooms: all_classrooms }, status: :bad_request
    render status: :ok, json: data
  end

  def show
    info_as_json
  end

  def create
    if @classroom
      error_as_json("Classroom #{existing.name} already exists")
    else
      # TODO: Figure out what to do with instructor email. Current plan is to add instructors to classrooms, use the
      # relationship to get emails, and remove the instructor_emails column from Students
      @classroom = Classroom.new(
        number: params[:number],
        name: params[:name],
        instructor_emails: params[:instructor_emails] || "fake_temp_email@ada.org",
        cohort_id: params[:cohort_id]
      )
      @classroom.save ? info_as_json("New classroom #{@classroom.name} created") : error_as_json(@classroom.errors)
    end
  end

  def update
    if @classroom.update(classroom_params)
      info_as_json("New classroom #{@classroom.name} updated")
    else
      error_as_json(@classroom.errors)
    end
  end

  def destroy
    NotImplementedError
  end

  private

  def classroom_params
    params.permit(:number, :name, :instructor_emails, :cohort_id)
  end

  def find_classroom
    @classroom = Classroom.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @classroom.as_json(only: [:id, :number, :name, :instructor_emails, :cohort_id]),
        message: message
    )
  end

end
