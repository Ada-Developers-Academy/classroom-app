# FIXME: clean up all of this before submitting/when we know what we're doing
require 'csv'
require 'faker'
require 'httparty'


# CREATE USERS
USER_FILE = Rails.root.join('db', './.capstone_seed_data/users_seed_data.csv')
puts "Loading raw works data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
#   student.id = row['id']
  user.name = row['name']
  user.provider = row['provider']
  user.uid = row['uid']
  user.github_name = row['github_name']
  user.role = row['role']

  if user.save
    puts "Created user: #{user.inspect}"
  else
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} user failed to save"
puts "done"

puts "*" * 30

########################################################################################################################
# CREATE COHORTS
# TODO: don't know if these dates are right
Cohort.create!(
  name: "C9",
  repo_name: "ada-C9",
  class_start_date: Date.new(2018,2,5),
  class_end_date: Date.new(2018,7,27),  # noooooooo 😭
  internship_start_date: Date.new(2018,8,6),
  internship_end_date: Date.new(2019,1,4),
  graduation_date: Date.new(2018,12,4)
)

########################################################################################################################
# CREATE CLASSROOMS
classrooms = [
  { number: 9, name: "Ampers", instructor_emails: "charles+classroom-local-pb-instructor@adadev.org", cohort_id: 1 },
  { number: 9, name: "Octos", instructor_emails: "charles+classroom-local-jelly-instructor@adadev.org", cohort_id: 1 }
]

classrooms.each do |c|
  Classroom.create!(c)
end

puts Classroom.all.inspect
puts "******** #{Classroom.count} CLASSROOMS CREATED*********\n\n"


########################################################################################################################
# CREATE CLASSROOMS
STUDENT_FILE = Rails.root.join('db', './.capstone_seed_data/student_seed_data.csv')
puts "Loading raw works data from #{STUDENT_FILE}"

student_failures = []
CSV.foreach(STUDENT_FILE, :headers => true) do |row|
  student = Student.new
#   student.id = row['id']
  student.name = row['name']
  student.preferred_name = row['preferred_name']
  student.email = row['email'].nil? ? Faker::Internet.email : row['email']
  student.github_name = row['github_name']
  student.uid = row['uid']
  puts row['classroom_id']
  student.classroom = Classroom.find(row['classroom_id'])
  # Classroom.find(row['classroom_id'])

  if student.save!
    puts "Created student: #{student.inspect}"
  else
    student_failures << student
    puts "Failed to save student: #{student.inspect}"
  end
end

puts "Added #{Student.count} student records"
puts "#{student_failures.length} student failed to save"
puts "done"

puts "*" * 30

# Create students
Student.create!(name: "Test Student 1", classroom: Classroom.first,
               github_name: "ada-student-1", email: "charles+classroom-local-student-1@adadev.org")
Student.create!(name: "Test Student 2", classroom: Classroom.last,
               github_name: "ada-student-2", email: "charles+classroom-local-student-2@adadev.org")


puts "******** #{Student.count} STUDENTS CREATED*********\n\n"

########################################################################################################################
# CREATE ASSIGNMENTS

ASSIGNMENT_FILE = Rails.root.join('db', './.capstone_seed_data/assignment_seed_data.csv')
puts "Loading raw works data from #{ASSIGNMENT_FILE}"

assignment_failures = []
(1..2).each do |curr_classroom_id|
  CSV.foreach(ASSIGNMENT_FILE, :headers => true) do |row|
    assignment = Assignment.new
    assignment.classrooms << Classroom.find(curr_classroom_id)
    assignment.repo_url = row['repo_url']

    if assignment.save!
      puts "Created assignment: #{assignment.inspect}"
    else
      assignment_failures << assignment
      puts "Failed to save assignment: #{assignment.inspect}"
    end
  end
end

puts "Added #{Assignment.count} assignment records"
puts "#{assignment_failures.length} assignment failed to save"
puts "done"

puts "*" * 30

puts "Against all odds, nothing broke! 👏😄"

# assignments.each do |assignment|
#   new_assignment = Assignment.new(assignment)
#   new_assignment.classrooms << Classroom.find(1)
#   # Makes 2nd assignment for us to play around with a many to many
#   new_assignment.classrooms << Classroom.find(2) if Assignment.count == 1 && Classroom.find_by(id: 2)
#   new_assignment.save!
#   puts "******** NEW ASSIGNMENT: #{new_assignment.classrooms.inspect} *********\n\n"
# end
# puts "******** #{Assignment.count} ASSIGNMENTS CREATED*********"


# # ASSIGNMENTS
# responses = HTTParty.get('https://api.github.com/users/Ada-C9/repos')
# responses.each do |response|
#   new_assignment = Assignment.new
#   new_assignment.classrooms << Classroom.find(1)
#   new_assignment.classrooms << Classroom.find(2)
#   new_assignment.repo_url = response['name']
#   new_assignment.save!
# end

# CSV.open("assignment_seed_data.csv", "wb") do |csv|
#   csv << Assignment.attribute_names
#   Assignment.all.each do |assignment|
#     csv << assignment.attributes.values
#   end
# end

# t.integer "student_id", null: false
# t.integer "assignment_id", null: false
# t.datetime "submitted_at"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.string "pr_url"
# t.string "feedback_url"
# t.integer "grade"
# t.bigint "instructor_id"
# t.index ["instructor_id"], name: "index_submissions_on_instructor_id"
# t.index ["student_id", "assignment_id"], name: "index_submissions_on_student_id_and_assignment_id", unique: true
#
# Assignment.all.each do |assignment|
#   # ASSIGNMENTS
#   responses = HTTParty.get(`https://api.github.com/repos/Ada-C9/#{assignment.repo_url}/pulls`)
#   responses.each do |response|
#     new_submission = Submission.new
#     new_group = SubmissionGroup.new
#
#     new_submission.sav
#     responses = HTTParty.get(`https://api.github.com/repos/mgraonic/TaskList/contributors`)
#
#     "url": "https://api.github.com/repos/Ada-C9/TaskList/pulls/46",
#     new_submission.assignment_id << Classroom.find(1)
#     new_submission.classrooms << Classroom.find(2)
#     new_submission.repo_url = response['name']
#     new_submission.save!
#   end
#
#   CSV.open("assignment_seed_data.csv", "wb") do |csv|
#     csv << Assignment.attribute_names
#     Assignment.all.each do |assignment|
#       csv << assignment.attributes.values
#     end
#   end
# end