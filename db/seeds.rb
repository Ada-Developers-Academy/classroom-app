# FIXME: this whole thing is a mess and is only for demo purposes for Capstone. If you're Charles and you're like
# "why are they doing this?!", we're very aware that this is not a best practices approach to populating data.

require 'csv'
require 'faker'
require 'httparty'

DEMO = true # If true, sets student names to fake names. Otherwise, uses students' real names.

def is_kirsten_or_leti?(student_name)
  student_name == "Kirsten Schumy" || student_name == "Leti Tran"
end

########################################################################################################### INSTRUCTORS
# CREATE INSTRUCTORS
INSTRUCTOR_FILE = Rails.root.join('db', './.capstone_seed_data/instructors_seed_data.csv')
puts "Loading raw works data from #{INSTRUCTOR_FILE}"

CSV.foreach(INSTRUCTOR_FILE, :headers => true) do |row|
  instructor = Instructor.new
  instructor.name = row['name']
  instructor.active = row['active']
  instructor.uid = row['uid']
  instructor.github_name = row['github_name']

  puts "Created instructor ##{instructor.id}" if instructor.save!
end

puts "#{"*" * 25 } #{Instructor.count} INSTRUCTORS CREATED #{"*" * 25 }\n\n"

################################################################################################################# USERS
# CREATE USERS
USER_FILE = Rails.root.join('db', './.capstone_seed_data/users_seed_data.csv')
puts "Loading raw works data from #{USER_FILE}"

CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.provider = row['provider']
  user.uid = row['uid']
  user.github_name = row['github_name']
  user.role = row['role']

  puts "Created user: ##{user.id}" if user.save!
end

puts "#{"*" * 25 } #{User.count} USERS CREATED #{"*" * 25 }\n\n"

############################################################################################################### COHORTS
# CREATE COHORT
# TODO: These dates may not be correct and should be checked.
Cohort.create!(
  name: "C9",
  repo_name: "Ada-C9",
  class_start_date: Date.new(2018,2,5),
  class_end_date: Date.new(2018,7,27),  # noooooooo 😭
  internship_start_date: Date.new(2018,8,6),
  internship_end_date: Date.new(2019,1,4),
  graduation_date: Date.new(2018,12,4)
)

puts "#{"*" * 25 } #{Cohort.count} COHORT CREATED #{"*" * 25 }\n\n"

############################################################################################################ CLASSROOMS
# CREATE CLASSROOMS
[
  {
    number: 9,
    name: "Ampers",
    instructor_emails: "charles+classroom-local-pb-instructor@adadev.org",
    cohort_id: 1
  },
  {
    number: 9,
    name: "Octos",
    instructor_emails: "charles+classroom-local-jelly-instructor@adadev.org",
    cohort_id: 1
  }
].each { |c| Classroom.create!(c) }

puts "#{"*" * 25 } #{Classroom.count} CLASSROOMS CREATED #{"*" * 25 }\n\n"

############################################################################################################## STUDENTS
# CREATE STUDENTS
STUDENT_FILE = Rails.root.join('db', './.capstone_seed_data/student_seed_data.csv')
puts "Loading raw works data from #{STUDENT_FILE}"

CSV.foreach(STUDENT_FILE, :headers => true) do |row|
  student = Student.new

  # If in DEMO mode and if student is not Kirsten or Leti, sets demo_name to a random Harry Potter name.
  # The rationale for this is to: 1) ensure student privacy and 2) allow for the program to display Leti and Kirsten's
  # names for the grades, which are of course perfect scores.
  demo_name = DEMO && !is_kirsten_or_leti?(row['name']) ? Faker::HarryPotter.character : nil

  student.name = demo_name || row['name']
  student.preferred_name = demo_name || row['preferred_name']
  student.email = row['email'].nil? ? Faker::Internet.email : row['email']
  student.github_name = row['github_name']
  student.uid = row['uid']
  student.classroom = Classroom.find(row['classroom_id'])

  puts "Created student ##{student.id}" if student.save!
end

puts "#{"*" * 25 } #{Student.count} STUDENTS CREATED #{"*" * 25 }\n\n"

########################################################################################################### ASSIGNMENTS
# CREATE ASSIGNMENTS
ASSIGNMENT_FILE = Rails.root.join('db', './.capstone_seed_data/assignment_seed_data.csv')
puts "Loading raw works data from #{ASSIGNMENT_FILE}"

CSV.foreach(ASSIGNMENT_FILE, :headers => true) do |row|
  assignment = Assignment.new
  assignment.name = row['name']
  assignment.repo_url = row['repo_url']
  assignment.due_date = Date.parse(row['due_date']) # HACK: due dates were made up for the seed file
  assignment.classroom_id = row['classroom_id']

  puts "Created assignment ##{assignment.id}" if assignment.save!
end

puts "#{"*" * 25 } #{Assignment.count} ASSIGNMENTS CREATED #{"*" * 25 }\n\n"

########################################################################################################### SUBMISSIONS
# CREATE SUBMISSIONS
# This was built from data for prs and only has one student for each submission. It also only accounts for turned in
# submissions, but in the real world, this would include all submissions, regardless of if the student turned a
# submission in or not. We left this out of the demo because we prioritized other features.

# We did not implemented getting the actual feedback provider, and this workaround was just for the Capstone demo.
# The Todo doc covers our vision on this (or will when we're done writing it).
AMPERS_INSTRUCTORS = ["CheezItMan", "tildeee"]
OCTOS_INSTRUCTORS = ["droberts-ada", "kariabancroft"]

# Grades are assigned by accessing grade_standards at a random index. Multiples of the same entries is done to increase
# the likelihood of the desired results (i.e. having grades skew more positive).
grade_standards = [
    :not_standard,
    :approach_standard, :approach_standard,
    :meet_standard, :meet_standard, :meet_standard, :meet_standard
]

# Use 'all_submissions_seed_2.csv' for the Ampers submissions, and 'all_submissions_seed.csv' both classes submissions.
# Current implementation of the front end
SUBMISSION_FILE = Rails.root.join('db', './.capstone_seed_data/all_submissions_seed_2.csv')
puts "Loading raw works data from #{SUBMISSION_FILE}"

CSV.foreach(SUBMISSION_FILE, :headers => true) do |row|
  new_submission = Submission.new
  new_submission.assignment_id = row["assignment_id"]
  new_submission.submitted_at = row["submitted_at"]
  new_submission.pr_url = row["pr_url"] # TODO: need to change name. This should be the pr issue number from GH.
  new_submission.student_ids = row["student_ids"]
  # HACK: only guaranteed to work correctly when there is one student. The data for the demo only has one student
  # per submission. There is a fairly big bug when attempting to add more than one student. Details about this bug
  # will be in the to do doc.
  new_submission.grade =
      is_kirsten_or_leti?(new_submission.students.first.name) ? :meet_standard : grade_standards.sample

  # HACK: Should not require the assignment name to end with `(CS Fun)` for it to be assigned to Shruti, nor should the
  # other instructors be assigned this way. This was done just for the demo.
  new_submission.feedback_provider =
    if new_submission.assignment.name.match(/.(\(CS Fun\))$/)
      Instructor.find_by(github_name: "shrutivanw")
    elsif new_submission.assignment.classroom.name == "Ampers"
      Instructor.find_by(github_name: AMPERS_INSTRUCTORS[rand(0..1)])
    else
      Instructor.find_by(github_name: OCTOS_INSTRUCTORS[rand(0..1)])
    end

  puts "Created assignment ##{new_submission.id}" if new_submission.save!
end

puts "#{"*" * 25 } #{Submission.count} SUBMISSIONS CREATED #{"*" * 25 }\n\n"

puts "\n\nAgainst all odds, nothing broke! 😄👏💃🏆🎉"
