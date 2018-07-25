# FIXME: clean up all of this before submitting/when we know what we're doing
require 'csv'
require 'faker'
require 'httparty'


# CREATE USERS
INSTRUCTOR_FILE = Rails.root.join('db', './.capstone_seed_data/instructors_seed_data.csv')
puts "Loading raw works data from #{INSTRUCTOR_FILE}"

instructor_failures = []
CSV.foreach(INSTRUCTOR_FILE, :headers => true) do |row|
  instructor = Instructor.new
#   student.id = row['id']
  instructor.name = row['name']
  instructor.active = row['active']
  instructor.uid = row['uid']
  instructor.github_name = row['github_name']
  # instructor.role = row['role']

  if instructor.save!
    puts "Created instructor ##{instructor.id}"
  end
end

puts "Added #{Instructor.count} instructor records"
puts "#{instructor_failures.length} instructor failed to save"
puts "done"

puts "*" * 30

########################################################################################################################

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

  if user.save!
    puts "Created user: ##{user.inspect}"
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
  repo_name: "Ada-C9",
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
    puts "Created student ##{student.id}"
  end
end

puts "Added #{Student.count} student records"
puts "#{student_failures.length} student failed to save"
puts "done"

puts "*" * 30

# # Create students
# Student.create!(name: "Test Student 1", classroom: Classroom.first,
#                github_name: "ada-student-1", email: "charles+classroom-local-student-1@adadev.org")
# Student.create!(name: "Test Student 2", classroom: Classroom.last,
#                github_name: "ada-student-2", email: "charles+classroom-local-student-2@adadev.org")


puts "******** #{Student.count} STUDENTS CREATED*********\n\n"

########################################################################################################################
# CREATE ASSIGNMENTS

ASSIGNMENT_FILE = Rails.root.join('db', './.capstone_seed_data/assignment_seed_data.csv')
puts "Loading raw works data from #{ASSIGNMENT_FILE}"

assignment_failures = []
(1..2).each do |curr_classroom_id|
  CSV.foreach(ASSIGNMENT_FILE, :headers => true) do |row|
    assignment = Assignment.new
    assignment.name = row['name']
    assignment.repo_url = row['repo_url']
    # assignment.classroom_id = curr_classroom_id
    curr_classroom = Classroom.find(row['classroom_id'])
    curr_classroom.assignments << assignment

    puts "Created assignment ##{assignment.id}" if assignment.save!
    # curr_classroom << assignment
  end
end

puts "Added #{Assignment.count} assignment records"
puts "#{assignment_failures.length} assignment failed to save"
puts "done"



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


SUBMISSION_FILE = Rails.root.join('db', './.capstone_seed_data/all_submissions_seed.csv')
puts "Loading raw works data from #{SUBMISSION_FILE}"

CSV.foreach(SUBMISSION_FILE, :headers => true) do |row|
  new_submission = Submission.new

  sub_stu = Student.find_by(id: row["student_id"])
  new_submission.assignment_id = row["assignment_id"]
  new_submission.submitted_at = row["submitted_at"]
  new_submission.pr_url = row["pr_url"] # TODO: need to change
  new_submission.student_id = row["student_id"]
  new_submission.students << sub_stu

  if new_submission.save!
    puts "Created assignment ##{new_submission.id}"
  end
end

puts "*" * 30

puts "Against all odds, nothing broke! 👏😄"
# end


##############
# Dir.foreach('db/.capstone_seed_data/seeeeds/') do |per_file|
#   next if per_file == "." || per_file == ".."
#   urll = "./.capstone_seed_data/seeeeds/#{per_file}"
#   submission_file = Rails.root.join('db', urll)
#   CSV.foreach(submission_file, :headers => true) do |row|
#     new_submission = Submission.new
#
#     sub_stu = Student.find_by(id: row["student_id"])
#     new_submission.assignment_id = row["assignment_id"]
#     new_submission.submitted_at = row["submitted_at"]
#     new_submission.pr_url = row["pr_url"] # need to change
#     new_submission.student_id = row["student_id"]
#     new_submission.students << sub_stu
#
#     if new_submission.save!
#       puts "Created assignment"
#       # else
#       #   assignment_failures << assignment
#       #   puts "Failed to save assignment: #{assignment.inspect}"
#     end
#   end
# end


####################################################

# curr_sub_id = 36
#
# # Assignment.inf.all.each do |assignment|
#   # puts assignment.repo_url.inspect
# curr_assignment = Assignment.find(curr_sub_id)
# all_students = Student.all.collect {|stu| stu.github_name}
#
# url = "https://api.github.com/repos/Ada-C9/#{curr_assignment.repo_url}/pulls"
# pull_responses = HTTParty.get(url, query: { "page" => 1, "per_page" => 100 },
#                               headers: {"user-agent" => "rails", "Authorization" => "token ade923f3c84d7548fe436999faf6452aa03c3f1d"})
# # puts pull_responses.inspect
# pull_responses.each do |pr|
#   # puts pr["user"].inspect
#   pr_user_uid = pr["user"]["id"]
#   next if Instructor.find_by(uid: pr_user_uid) # Thanks Dan
#   # next if Submission.find_by(uid: pr_user_uid) # Thanks Adies
#   # puts pr_user_uid
#   # new_group = SubmissionGroup.new
#   new_submission = Submission.new
#
#   # group_stu = Student.where(uid: pr_user_uid)
#   all_students.include?(pr["user"]["login"]) ? all_students.delete(pr["user"]["login"]) : next
#   # all_students.delete_if { |stuu| stuu == pr["user"]["login"]}
#   sub_stu = Student.find_by(uid: pr_user_uid)
#   # puts sub_stu.github_name
#   new_submission.assignment_id = curr_assignment.id
#   new_submission.submitted_at = pr["updated_at"]
#   new_submission.pr_url = pr["url"] # need to change
#   new_submission.student_id = sub_stu.id
#   new_submission.students << sub_stu
#
#   # new_submission.feedback_url =
#   #
#   # new_group.save!
#   # new_submission.submission_group = new_group
#   new_submission.save!
#   # puts Submission.last.inspect
# end

# new_file_name = "all_submissions_seed.csv"
# CSV.open(new_file_name, "wb") do |csv|
#   csv << Submission.attribute_names
#   Submission.all.each do |submission|
#     csv << submission.attributes.values
#   end
#   # csv << all_students
# end
# puts all_students