class ClassroomsController < ApplicationController
  load_and_authorize_resource
  # before_action :find_classroom, only: [:show, :edit, :update, :destroy]

  def index
    data = Classroom.all
    # render json: { classrooms: all_classrooms }, status: :bad_request
    render status: :ok, json: data
  end

  def show
    NotImplementedError
  end

  def create
    existing = Classroom.find_by(id: params[:id])
    if existing
      render json: { errors: "Classroom #{existing.name} already exists" }, status: :bad_request
      return
    else
      classroom = Classroom.new(
        number: params[:number],
        name: params[:name],
        instructor_emails: params[:instructor_emails], #|| "fake_email_because_we_havent_decided_on_the_instructors_and_classroom_issue@ada.org",
        cohort_id: params[:cohort_id]
      )
      # new_classroom.cohort = Cohort.find_by(id: params[:cohort_id])

      if classroom.save
        render json: { message: "New classroom #{classroom.name} created" }, status: :ok
      else
        render json: { errors: "New cohort not created"}, status: :bad_request
      end

    end
  end

  def update
    NotImplementedError
  end

  def delete
    NotImplementedError
  end

  private
  def classroom_params
    # hello
    params.permit(:number, :name, :instructor_emails, :cohort_id)
  end

  def find_classroom
    # @classroom = Classroom.find_by(params[:id])
  end

end
