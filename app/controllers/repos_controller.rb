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
    @repo = Repo.new(repo_params)

    if @repo.save
      redirect_to repos_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    @repo = Repo.find_by_id(params[:id])
    if !@repo
      flash[:error] = "Repo not found."
      redirect_to repos_path
    end
    @max_size = Cohort.all.length
  end

  def update
    @repo = Repo.find(params[:id])
    if @repo.update_attributes(repo_params)
      @repo.cohorts.build
      redirect_to repos_path
    else
      render :edit, :status => :bad_request
    end
  end

  def destroy
    repo = Repo.find_by_id(params[:id])
    if repo
      repo.destroy
    else
      flash[:error] = "Repo not found."
    end
    redirect_to repos_path
  end

  private

  def repo_params
    params.require(:repo).permit(:repo_url, :individual, :cohort_ids => [] )
  end
end
