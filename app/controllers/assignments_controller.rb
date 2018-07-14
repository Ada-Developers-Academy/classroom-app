require 'github'

class AssignmentsController < ApplicationController
  load_and_authorize_resource except: [:show]
  load_and_authorize_resource :assignment, parent: true, only: [:show]
  load_and_authorize_resource :classroom, parent: false, only: [:show]

  def index
    # new code for api wrapper:
    if params[:query]
      data = RepoWrapper.search(params[:query])
    else
      data = Assignment.all
    end
    render status: :ok, json: data
  end

  def show
    # original code for views:
    gh = GitHub.new(session[:token])

    @all_data = gh.retrieve_student_info(@assignment, @cohort)

    # render(
    #   status: :ok,
    #   json: @assignment.as_json(
    #     only: [:id, :repo_url]
    #   )
    # )
    # # Should we change this?
    #

  end

  def new
  end

  def create
    if @assignment.save
      redirect_to assignments_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    @max_size = Classroom.all.length
  end

  def update
    if @assignment.update_attributes(assignment_params)
      @assignment.classrooms.build
      redirect_to assignments_path
    else
      render :edit, :status => :bad_request
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path
  end

  private

  rescue_from ActiveRecord::RecordNotFound do |ex|
    flash[:error] = "Resource not found."
    redirect_to assignments_path
  end

  def assignment_params
    params.require(:assignment).permit(:repo_url, :individual, :classroom_ids => [] )
  end
end
