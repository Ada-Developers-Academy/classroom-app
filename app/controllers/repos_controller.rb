class ReposController < ApplicationController
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:id])
    data = HTTParty.get("https://api.github.com/repos/#{ @repo.repo_url }/pulls")
    students = Student.where(cohort_num: @repo.cohort_num)
    pr_student_list = []
    data.parsed_response.each do |d|
      pr_student_list << d["user"]["login"].downcase
    end

    student_list = students.sort
    pr_list = pr_student_list.sort

    @new_hash = {}
    student_list.each do |stud|
      if pr_list.include?(stud.github_name.downcase)
        submitted = true
      else
        submitted = false
      end
      @new_hash[stud.github_name] = {name: stud.name, submitted: submitted}
    end
  end

  def new
    @repo = Repo.new
  end

  def create
    Repo.create(repo_params[:repo])
    redirect_to "/"
  end

  private

  def repo_params
    params.permit(repo: [:cohort_num, :repo_url])
  end
end
