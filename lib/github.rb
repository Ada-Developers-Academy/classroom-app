require 'httparty'
require 'pr_student'

# TODO: review this class and logic involving it when we start with SubmissionGroup
class GitHub
  attr_reader :token

  def initialize(token)
    @token = token
  end

  # Overall method that will pull together all pieces
  def retrieve_student_info(assignment, classroom)
    # First, call the API to get the PR data
    pr_info = get_prs(assignment.repo_url)

    # Get the students in the classroom
    classroom_students = Student.where(classroom_id: classroom.id).sort

    # Use the PR data to construct the list of students submitted
    pr_students = pr_student_submissions(assignment, pr_info, classroom_students)

    # Add te student info for those who haven't submitted
    pr_students = add_missing_students(pr_students, classroom_students, assignment)
    return pr_students
  end

  def pr_student_submissions(assignment, pr_data, students)
    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_data.parsed_response.each do |pull_request|
      # Individual project
      if assignment.individual
        submission = individual_student(students, assignment, pull_request)
        pr_student_list << submission if submission != nil
      else # Group project
        pr_student_list.concat(group_project(students, pull_request, assignment))
      end
    end

    return pr_student_list
  end

  def add_missing_students(submissions, students, assignment)
    submitted_students = submissions.map{ |submit| submit.student.id }
    missing_students = students.reject { |stud| submitted_students.include?(stud.id) }

    missing_students.each do |stud|
      # Do we already have a submission for this student?
      submit = Submission.find_or_create_by(student: stud, assignment: assignment)
      submissions << submit if submit.persisted?
    end

    return submissions
  end

  def individual_student(students, assignment, data)
    return create_student(students, data["user"]["login"].downcase, data["created_at"], assignment, data["html_url"])
  end

  def create_student(students, user, created_at, assignment, pr_url)
    student_model = students.find{ |s| s.github_name.downcase == user }

    if student_model
      # Do we already have a submission for this student?
      prev = Submission.find_by(student: student_model, assignment: assignment)

      if prev
        # update
        prev.submitted_at = created_at
        prev.pr_url = pr_url
        if prev.save
          return prev
        end
      else
        submit = Submission.new(student: student_model, submitted_at: created_at, assignment: assignment, pr_url: pr_url)

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

  def group_project(classroom_students, data, assignment)
    students = []
    url = contributors_url(data)
    return students unless url

    assignment_created = data["created_at"]
    pr_url = data["html_url"]

    contributors = make_request(url)
    github_usernames = classroom_students.map{ |stud| stud.github_name.downcase }

    contributors.each do |contributor|
      curr_github_username = contributor["login"].downcase

      # If the contributor is in the student list, add it!
      if github_usernames.include?(curr_github_username)
        student = create_student(classroom_students, curr_github_username, assignment_created, assignment, pr_url)
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
