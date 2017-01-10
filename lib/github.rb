require 'httparty'
require 'pr_student'

class GitHub
  AUTH = { :username => ENV["GITHUB"] }

  # Overall method that will pull together all pieces
  def self.retrieve_student_info(repo, cohort)
    # First, call the API to get the PR data
    pr_info = get_prs(repo.repo_url)

    # Get the students in the cohort
    cohort_students = Student.where(cohort_id: cohort.id).sort

    # Use the PR data to construct the list of students submitted
    pr_students = pr_student_submissions(repo, pr_info, cohort_students)

    # Add te student info for those who haven't submitted
    pr_students = add_missing_students(pr_students, cohort_students, repo)
    @all_data = pr_students
  end

  def self.pr_student_submissions(repo, pr_data, students)
    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_data.parsed_response.each do |pull_request|
      # Individual project
      if repo.individual
        submission = individual_student(students, repo, pull_request)
        pr_student_list << submission if submission != nil
      else # Group project
        pr_student_list.concat(group_project(students, pull_request))
      end
    end

    return pr_student_list
  end

  def self.add_missing_students(submissions, students, repo)
    submitted_students = submissions.map{ |submit| submit.student.id }
    missing_students = students.reject { |stud| submitted_students.include?(stud.id) }

    missing_students.each do |stud|
      # Do we already have a submission for this student?
      submit = Submission.find_by(student: stud, repo: repo)

      if submit
        submissions << submit
      else
        submit = Submission.new(student: stud, repo: repo)

        if submit.save
          submissions << submit
        end
      end
    end

    return submissions
  end

  def self.individual_student(students, repo, data)
    return create_student(students, data["user"]["login"].downcase, data["created_at"], repo, data["html_url"])
  end

  def self.create_student(students, user, created_at, repo, pr_url)
    student_model = students.find{ |s| s.github_name == user }

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

  def self.get_prs(repo_url)
    request_url = "https://api.github.com/repos/#{ repo_url }/pulls"

    pr_info = make_request(request_url)
    return pr_info
  end

  def self.group_project(cohort_students, data)
    url = data["head"]["repo"]["contributors_url"]
    repo_created = data["created_at"]
    repo_url = data["html_url"]

    contributors = make_request(url)
    github_usernames = cohort_students.map{ |stud| stud.github_name.downcase }

    result = []
    contributors.each do |contributor|
      curr_github_username = contributor["login"].downcase

      # If the contributor is in the student list, add it!
      if github_usernames.include?(curr_github_username)
        student = create_student(cohort_students, curr_github_username, repo_created, repo_url)
        result << student if student
      end
    end

    return result
  end

  def self.make_request(url)
    response = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => GitHub::AUTH)
    return response
  end
end
