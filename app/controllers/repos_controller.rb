require 'github'

class ReposController < ApplicationController
  load_and_authorize_resource except: [:show]
  load_and_authorize_resource :repo, parent: true, only: [:show]
  load_and_authorize_resource :cohort, parent: false, only: [:show]

  def index
  end

  def show
    gh = GitHub.new(session[:token])
    @all_data = gh.retrieve_student_info(@repo, @cohort)
  end

  def new
  end

  def create
    if @repo.save
      redirect_to repos_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    @max_size = Cohort.all.length
  end

  def update
    if @repo.update_attributes(repo_params)
      @repo.cohorts.build
      redirect_to repos_path
    else
      render :edit, :status => :bad_request
    end
  end

  def destroy
    @repo.destroy
    redirect_to repos_path
  end

  private

  rescue_from ActiveRecord::RecordNotFound do |ex|
    flash[:error] = "Resource not found."
    redirect_to repos_path
  end

  def repo_params
    params.require(:repo).permit(:repo_url, :individual, :cohort_ids => [] )
  end
end
