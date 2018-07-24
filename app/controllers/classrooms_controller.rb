class ClassroomsController < ApplicationController
  load_and_authorize_resource
  before_action :find_classroom, only: [:create, :show, :edit, :update, :destroy]

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
      render json: { errors: "Classroom #{existing.name} already exists" }, status: :bad_request
      return
    else
      classroom = Classroom.new(
        number: params[:number],
        name: params[:name],
        instructor_emails: params[:instructor_emails], #|| "fake_email_because_we_havent_decided_on_the_instructors_and_classroom_issue@ada.org",
        cohort_id: params[:cohort_id]
      )

      if classroom.save
        info_as_json("New classroom #{classroom.name} created")
      else
        render json: { errors: "New cohort not created"}, status: :bad_request
      end

    end
  end

  def update
    if @classroom.update(classroom_params)
      info_as_json("New classroom #{@classroom.name} updated")
    else
      render json: {errors: "Classroom could not be updated"}, status: :bad_request
    end
  end

  def delete
    NotImplementedError
  end

  private

  def classroom_params
    params.permit(:number, :name, :instructor_emails, :cohort_id)
  end

  def find_classroom
    @classroom = Classroom.find_by(id: params[:id])
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
        json: @classroom.as_json(only: [:id, :number, :name, :instructor_emails, :cohort_id]),
        message: message
    )
  end

end
