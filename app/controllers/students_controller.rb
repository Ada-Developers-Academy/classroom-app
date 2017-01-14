class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    #raise
    @student = Student.new(stud_params)

    if @student.save
      redirect_to students_path
    else
      render :new
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    Student.update(params[:id], stud_params)
    redirect_to students_path
  end

  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
    redirect_to students_path
  end

  private

  def stud_params
   params.require(:student).permit(:name, :cohort_id, :github_name, :email)
  end
end
