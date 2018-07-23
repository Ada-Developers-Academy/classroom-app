class StudentsController < ApplicationController
  load_and_authorize_resource # QUESTION: what does this actually do?
  before_action :find_student, only: [:show, :edit, :update, :destroy]


  def index
    data = Student.all
    render status: :ok, json: data
   end

  def create
    if @student.save
      redirect_to students_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    find_student
  end

  def update
    # if !@student.update(student_params)
    #   render :edit, :status => :bad_request
    # else
    #   redirect_to students_path
    # end
    # # if !@student.update(student_params)
    # #   render :edit, :status => :bad_request
    # # else
    # #   redirect_to students_path
    # # end
  end

  # @param :id
  # @return :student if provided a valid id
  # @return :error if not provided a valid id
  def show
    render json: { student: @student }, status: :ok
  end

  def destroy
    @student.destroy
    redirect_to students_path
  end

  private

  def find_student
    @student = Student.find_by(id: params[:id])
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    render json: { error: "#{ex}" }, status: :bad_request
  end

  def student_params
   params.require(:student).permit(:name, :classroom_id, :github_name, :email)
  end
end
