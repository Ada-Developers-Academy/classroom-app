# Create instructor
User.create!(name: "Test Instructor 1",
             provider: :github,
             uid: "30710012",
             github_name: "ada-instructor-1",
             role: "instructor")

puts "\n********USER CREATED!*********\n\n"

# Create cohorts
cohorts = [
  { number: 0, name: "Peanut Butter", instructor_emails: "charles+classroom-local-pb-instructor@adadev.org" },
  { number: 0, name: "Jelly", instructor_emails: "charles+classroom-local-jelly-instructor@adadev.org" }
]

cohorts.each do |c|
  Cohort.create!(c)
end
puts "******** #{Cohort.all.size} COHORTS CREATED*********\n\n"

# Create students
Student.create!(name: "Test Student 1", cohort: Cohort.first,
               github_name: "ada-student-1", email: "charles+classroom-local-student-1@adadev.org")
Student.create!(name: "Test Student 2", cohort: Cohort.last,
               github_name: "ada-student-2", email: "charles+classroom-local-student-2@adadev.org")
puts "******** #{Student.all.size} STUDENTS CREATED*********\n\n"


assignment = [
  { repo_url: "Ada-Test/PR-App-test-group", individual: false},
  { repo_url: "Ada-Test/PR-App-test-individual"}
]

assignment.each do |assignment|
  r = Assignment.create!(assignment)
  puts "********ASSIGNMENT #{r} CREATED*********\n\n"
  puts "********ASSIGNMENT.COHORTS: #{r.cohorts} *********"
  # it brakes here:
  # puts "********ASSIGNMENT COHORTS SIZE: #{r.cohorts.to_ary} *********"
  puts "********ASSIGNMENT.COHORTS.SIZE: #{r.cohorts.size} *********"
 r.cohorts << Cohort.all
  r.save
end
puts "******** #{Assignment.all.size} ASSIGNMENTS CREATED*********"