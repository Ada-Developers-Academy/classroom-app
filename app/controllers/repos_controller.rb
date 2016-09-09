class ReposController < ApplicationController
  AUTH = {:username => ENV["GITHUB"]}

  def index
    @repos = Repo.all
  end

  def show
    @repo = Repo.find(params[:repo_id])

    if !@repo
      flash[:error] = "Repository not found"
      redirect_to :back
    end

    @cohort = Cohort.find(params[:cohort_id])
    puts @cohort

    # Get all PRS
    request_url = "https://api.github.com/repos/#{ @repo.repo_url }/pulls"

    pr_info = HTTParty.get(request_url, headers: {"user-agent" => "rails"}, :basic_auth => AUTH)

    # Get list of students in the cohort
    cohort_students = Student.where(cohort_id: @cohort.id).sort

    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_info.parsed_response.each do |data|
      # Individual project
      if @repo.individual
        student_hash = individual_student(cohort_students, data)
        pr_student_list << student_hash if student_hash != nil
      else # Group project
        puts "GROUP GROUP GROUP GROUP"
        pr_student_list.concat(group_project(cohort_students, data, 3))
      end
    end

    ids = pr_student_list.compact.map { |s| s[:student].id }

    # Map list of students against the students who have submitted
    missing_students = cohort_students.map { |s| !ids.include?(s.id)? s : nil }

    missing_students.compact.each do |miss|
      stud_hash = {}
      stud_hash[:user] = nil
      stud_hash[:created_at] = nil
      stud_hash[:student] = miss

      pr_student_list << stud_hash if stud_hash[:student]
    end

    @all_data = pr_student_list
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

  def create_student(cohort_students, user, created_at, repo_url)
    stud_hash = {}
    stud_hash[:user] = user.downcase
    stud_hash[:created_at] = DateTime.parse(created_at)
    stud_hash[:url] = repo_url
    stud_hash[:student] = cohort_students.find{ |s| s.github_name == stud_hash[:user] }

    if stud_hash[:student]
      return stud_hash
    else
      return nil
    end
  end

  def individual_student(cohort_students, data)
    return create_student(cohort_students, data["user"]["login"], data["created_at"], data["html_url"])
  end

  def group_project(cohort_students, data, group_size)
    url = data["commits_url"]

    if url
      commit_info = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => AUTH)
      repo_created = data["created_at"]
      repo_url = data["html_url"]

      # Only include one entry for each student
      count = 0
      output = Set.new
      commit_info.parsed_response.each do |commit|
        if count == group_size
          break
        end

        # Ensure count is only incremented for unique authors
        if commit["author"] != nil && !output.include?(commit["author"]["login"])
          count += 1
          output << commit["author"]["login"]
        end
      end

      result = []
      output.each do|stud|
        student = create_student(cohort_students, stud, repo_created, repo_url)
        result << student if student
      end

      return result
    end
  end
end
