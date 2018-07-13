class StudentsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    if @student.save
      redirect_to students_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    if !@student
      flash[:error] = "Student not found."
      redirect_to students_path
    end
  end

  def update
    if !@student.update(student_params)
      render :edit, :status => :bad_request
    else
      redirect_to students_path
    end
  end

  def index
  end

  def show
  end

  def destroy
    @student.destroy
    redirect_to students_path
  end

  private

  rescue_from ActiveRecord::RecordNotFound do |ex|
    flash[:error] = "Student not found."
    redirect_to students_path
  end

  def student_params
   params.require(:student).permit(:name, :classroom_id, :github_name, :email)
  end
end
