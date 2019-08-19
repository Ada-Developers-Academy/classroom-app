require 'httparty'
require 'pr_student'

class GitHub
  attr_reader :token

  def initialize(token)
    @token = token
  end

  # Overall method that will pull together all pieces
  def retrieve_student_info(repo, cohort)
    # First, call the API to get the PR data
    pr_info = get_prs(repo.repo_url)

    # Get the students in the cohort
    cohort_students = Student.where(cohort_id: cohort.id).sort

    # Use the PR data to construct the list of students submitted
    pr_students = pr_student_submissions(repo, pr_info, cohort_students, cohort.name)

    # Add te student info for those who haven't submitted
    pr_students = add_missing_students(pr_students, cohort_students, repo)
    return pr_students
  end

  def pr_student_submissions(repo, pr_data, students, cohort_name)
    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_data.parsed_response.each do |pull_request|
      # Individual project
      if repo.individual
        submission = individual_student(students, repo, pull_request)
        pr_student_list << submission if submission != nil
      else # Group project
        pr_student_list.concat(group_project(students, pull_request, repo, cohort_name))
      end
    end

    return pr_student_list
  end

  def add_missing_students(submissions, students, repo)
    submitted_students = submissions.map{ |submit| submit.student.id }
    missing_students = students.reject { |stud| submitted_students.include?(stud.id) }

    missing_students.each do |stud|
      # Do we already have a submission for this student?
      submit = Submission.find_or_create_by(student: stud, repo: repo)
      submissions << submit if submit.persisted?
    end

    return submissions
  end

  def individual_student(students, repo, data)
    return create_student(students, data["user"]["login"].downcase, data["created_at"], repo, data["html_url"])
  end

  def create_student(students, user, created_at, repo, pr_url)
    student_model = students.find{ |s| s.github_name.downcase == user }

    if student_model
      # Do we already have a submission for this student?
      prev = Submission.find_by(student: student_model, repo: repo)

      if prev
        # update
        prev.submitted_at = created_at
        prev.pr_url = pr_url
        if prev.save
          return prev
        end
      else
        submit = Submission.new(student: student_model, submitted_at: created_at, repo: repo, pr_url: pr_url)

        if submit.save
          return submit
        end
      end
    end
  end

  def get_prs(repo_url)
    request_url = "https://api.github.com/repos/#{ repo_url }/pulls"

    pr_info = make_request(request_url)
    return pr_info
  end

  def group_project(cohort_students, data, repo, cohort_name)
    students = []
    url = contributors_url(data)
    return students unless url

    repo_created = data["created_at"]
    pr_url = data["html_url"]

    contributors = make_request(url)
    github_usernames = cohort_students.map{ |stud| stud.github_name.downcase }

    contributor_usernames = contributors.map { |c| c["login"].downcase }
    contributor_usernames << data["user"]["login"].downcase
    contributor_usernames.uniq!

    _, repo_name = repo.repo_url.split("/")

    # Only trigger if we don't have a full pair.
    if repo_name && contributor_usernames.length < 2
      pr_title = data["title"].strip
      name_title = pr_title
                     .sub(/[[:punct:]\s]*(?:#{cohort_name})[[:punct:]\s]*/i, '')
                     .sub(/[[:punct:]\s]*(?:#{repo_name})[[:punct:]\s]*/i, '')
      names = name_title.split(/\s?(?:(?:[&+,;]+)|(?: and ))\s?/)

      names.each do |name|
        # Get all the students that have this name as part of their name.
        matches = cohort_students.select { |s| s.name =~ /#{name}/i }

        # Add the user if the name was unambiguous.
        contributor_usernames << matches.first.github_name if matches.length == 1
      end
    end

    contributor_usernames.each do |contributor|
      # If the contributor is in the student list, add it!
      if github_usernames.include?(contributor)
        student = create_student(cohort_students, contributor, repo_created, repo, pr_url)
        students << student if student
      end
    end

    return students
  end

  def make_request(url)
    response = HTTParty.get(url, query: { "page" => 1, "per_page" => 100 },
                            headers: {"user-agent" => "rails", "Authorization" => "token #{ token }"})
    return response
  end

  def contributors_url(pr_data)
    return nil if pr_data.nil? ||
                  pr_data["head"].nil? ||
                  pr_data["head"]["repo"].nil?

    pr_data["head"]["repo"]["contributors_url"]
  end
end
