require 'github'

class AssignmentsController < ApplicationController
  load_and_authorize_resource except: [:show]
  load_and_authorize_resource :assignment, parent: true, only: [:show]
  load_and_authorize_resource :cohort, parent: false, only: [:show]

  def index
  end

  def show
    gh = GitHub.new(session[:token])
    @all_data = gh.retrieve_student_info(@assignment, @cohort)
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
    @max_size = Cohort.all.length
  end

  def update
    if @assignment.update_attributes(assignment_params)
      @assignment.cohorts.build
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
    params.require(:assignment).permit(:repo_url, :individual, :cohort_ids => [] )
  end
end
