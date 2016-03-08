class ReposController < ApplicationController
  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:id])

    # Get all PRS
    request_url = "https://api.github.com/repos/#{ @repo.repo_url }/pulls"
    pr_info = HTTParty.get(request_url)

    # Get list of students in the cohort
    cohort_students = Student.where(cohort_num: @repo.cohort_num).sort

    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_info.parsed_response.each do |d|
      pr_user = d["user"]["login"].downcase
      pr_student_list << pr_user

      # Must review committers for pair or group projects
      if !@repo.individual
        commit_info = HTTParty.get(d["commits_url"])
        output = commit_info.parsed_response.uniq do |commit|
          if commit["author"] != nil
            commit["author"]["login"]
          end
        end
        puts "HEYHEYHEYHEY #{output}"
      end
    end

    pr_list = pr_student_list.sort

    @new_hash = {}
    cohort_students.each do |stud|
      if pr_list.include?(stud.github_name.downcase)
        submitted = true
      else
        submitted = false
      end
      @new_hash[:github] = stud.github_name
      @new_hash[:name] = stud.name
      @new_hash[:submitted] = submitted
      @new_hash[:email] = stud.name + "@gmail.com"
      # @new_hash[stud.github_name] = {name: stud.name, submitted: submitted, email: }
    end

    # DEFAULT FOR NOW
    @new_hash[:instructor_cc] = "kari@adadevelopersacademy.org"
    @new_hash[:subject_line] = @repo.repo_url + " PR submission"

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
end
