class ReposController < ApplicationController
  AUTH = {:username => ENV["GITHUB"]}

  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:id])

    # Get all PRS
    request_url = "https://api.github.com/repos/#{ @repo.repo_url }/pulls"

    pr_info = HTTParty.get(request_url, headers: {"user-agent" => "rails"}, :basic_auth => AUTH)

    # Get list of students in the cohort
    cohort_students = Student.where(cohort_num: @repo.cohort_num).sort

    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_info.parsed_response.each do |d|
      pr_user = d["user"]["login"].downcase
      pr_student_list << pr_user

      # Must review committers for pair or group projects
      if !@repo.individual
        pr_student_list = handle_groups(d["commits_url"], pr_student_list)
      end
    end

    pr_student_list.select!{ |p| p != nil }
    pr_student_list.uniq!
    pr_list = pr_student_list.sort

    @all_data = []
    cohort_students.each do |stud|
      if pr_list.include?(stud.github_name.downcase)
        submitted = true
      else
        submitted = false
      end
      student_hash = {}
      student_hash[:github] = stud.github_name
      student_hash[:name] = stud.name
      student_hash[:submitted] = submitted
      student_hash[:email] = stud.name + "@gmail.com"
      # student_hash[stud.github_name] = {name: stud.name, submitted: submitted, email: }
      # DEFAULT FOR NOW
      student_hash[:instructor_cc] = "kari@adadevelopersacademy.org"
      student_hash[:subject_line] = @repo.repo_url + " PR submission"
      @all_data << student_hash
    end

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
  end

  def update
    Repo.update(params[:id], repo_params)
    redirect_to repos_path
  end

  def destroy
    repo = Repo.find(params[:id])
    repo.destroy
    redirect_to repos_path
  end

  private

  def repo_params
    params.require(:repo).permit(:cohort_num, :repo_url, :individual)
  end

  def handle_groups(url, pr_student_list)
    commit_info = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => AUTH)
    output = commit_info.parsed_response.map do |commit|
      if commit["author"] != nil
        commit["author"]["login"].downcase
      end
    end
    output.uniq!

    pr_student_list = pr_student_list + output
  end
end
