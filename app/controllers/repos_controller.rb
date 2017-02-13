require 'github'

class ReposController < ApplicationController
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find_by_id(params[:repo_id])

    if !@repo
      flash[:error] = "Repository not found"
      redirect_to :back
    end

    @cohort = Cohort.find_by_id(params[:cohort_id])
    if !@cohort
      flash[:error] = "Cohort not found"
      redirect_to :back
    end

    gh = GitHub.new(session[:token])
    @all_data = gh.retrieve_student_info(@repo, @cohort)
  end

  def new
    @repo = Repo.new
  end

  def create
    Repo.create(repo_params)
    redirect_to repos_path
  end

  def edit
    @repo = Repo.find(params[:id])
    @max_size = Cohort.all.length
  end

  def update
    updated = Repo.find(params[:id])
    if updated.update_attributes(repo_params)
      updated.cohorts.build
      redirect_to repos_path
    else
      flash[:error] = "An error has occurred"
      redirect_to :back
    end
  end

  def destroy
    repo = Repo.find(params[:id])
    repo.destroy
    redirect_to repos_path
  end

  private

  def repo_params
    params.require(:repo).permit(:repo_url, :individual, :cohort_ids => [] )
  end
end
