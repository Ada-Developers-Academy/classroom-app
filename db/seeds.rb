# Create instructor
User.create(name: "Test Instructor 1", provider: :github, uid: "30710012", role: "instructor")

# Create cohorts
cohorts = [
  { number: 0, name: "Peanut Butter", instructor_emails: "charles+classroom-local-pb-instructor@adadev.org" },
  { number: 0, name: "Jelly", instructor_emails: "charles+classroom-local-jelly-instructor@adadev.org" }
]

cohorts.each do |c|
  Cohort.create(c)
end

# Create students
Student.create(name: "Test Student 1", cohort: Cohort.first,
               github_name: "ada-student-1", email: "charles+classroom-local-student-1@adadev.org")
Student.create(name: "Test Student 2", cohort: Cohort.last,
               github_name: "ada-student-2", email: "charles+classroom-local-student-2@adadev.org")

repos = [
  { repo_url: "Ada-Test/PR-App-test-group", individual: false},
  { repo_url: "Ada-Test/PR-App-test-individual"}
]

repos.each do |repo|
  r = Repo.create(repo)
  r.cohorts << Cohort.all
  r.save
end
