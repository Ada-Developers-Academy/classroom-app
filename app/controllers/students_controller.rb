class StudentsController < ApplicationController
  load_and_authorize_resource # QUESTION: what does this actually do?

  def index
    # Code for constructing internal api to be called by front-end:
    data = Student.all
    # data = data.paginate(page: params[:p], per_page: params[:n])
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
    @student = Student.find_by(id: params[:id])
    # if student
    #
    # end
    # if !@student
    #   flash[:error] = "Student not found."
    #   redirect_to students_path
    # end
  end

  def update
    if !@student.update(student_params)
      render :edit, :status => :bad_request
    else
      redirect_to students_path
    end
    # if !@student.update(student_params)
    #   render :edit, :status => :bad_request
    # else
    #   redirect_to students_path
    # end
  end

  def show
    # puts "reached Student#show"
    # data = Student.find_by(@student.id)

    #   render json: data.as_json(
    #   only: [:name, :email, :github_name, :cohort]
    # )
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
