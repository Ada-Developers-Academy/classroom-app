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

  def create_batch
    students_file = params[:students_csv]
    raise IOError.new('No students CSV file uploaded') unless students_file
    students_csv = CSV.parse(students_file.read).reject(&:empty?)

    Student.transaction do
      students_attrs = students_csv.map do |row|
        {
          cohort: Cohort.find_by(number: row[0], name: row[1]),
          name: row[2],
          github_name: row[3],
          email: row[4],
        }
      end

      students_attrs.each do |attrs|
        student = Student.create(attrs)
        raise ActiveRecord::RecordInvalid.new(student) unless student.persisted?
      end
    end

    flash[:error] = nil
    flash[:notice] = "Successfully created #{students_csv.count} students."
    redirect_to students_path
  rescue ActiveRecord::RecordInvalid => ex
    flash[:error] = "could not create all students (#{ex.message})"
    @student = Student.new
    render :new, status: :bad_request
  rescue IOError, CSV::MalformedCSVError => ex
    flash[:error] = "could not use students CSV file (#{ex.message})"
    @student = Student.new
    render :new, status: :bad_request
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
   params.require(:student).permit(:name, :cohort_id, :github_name, :email)
  end
end
