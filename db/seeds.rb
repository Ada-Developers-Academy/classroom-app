# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create Cohort 4 students
cohort_4 = [
  { name: "Amy", cohort_num: 4, github_name: "lachuchilla"},
  { name: "Annalee", cohort_num: 4, github_name: "annaleeherrera"},
  { name: "Audrey", cohort_num: 4, github_name: "dreedle"},
  { name: "Brittany", cohort_num: 4, github_name: "brittanykohler"},
  { name: "Claire", cohort_num: 4, github_name: "cshekta"},
  { name: "Daphne", cohort_num: 4, github_name: "daphnegold"},
  { name: "Desiree", cohort_num: 4, github_name: "desireepoland"},
  { name: "Emily", cohort_num: 4, github_name: "emgord"},
  { name: "Hailey", cohort_num: 4, github_name: "wesleywillis"},
  { name: "Jenna", cohort_num: 4, github_name: "jennaplusplus"},
  { name: "Jennie", cohort_num: 4, github_name: "jbuechs"},
  { name: "Jessica", cohort_num: 4, github_name: "noglows"},
  { name: "Katherine", cohort_num: 4, github_name: "kdefliese"},
  { name: "Kelly", cohort_num: 4, github_name: "kedevlin"},
  { name: "Lauren", cohort_num: 4, github_name: "lgranger"},
  { name: "Logan", cohort_num: 4, github_name: "loganmeetsworld"},
  { name: "Meighan", cohort_num: 4, github_name: "knaydee"},
  { name: "Rebecca", cohort_num: 4, github_name: "rmtolmach"},
  { name: "Ricky", cohort_num: 4, github_name: "hougland"},
  { name: "Riley", cohort_num: 4, github_name: "rileyspicer"},
  { name: "Sarah T", cohort_num: 4, github_name: "trowbrsa"},
  { name: "Tamar", cohort_num: 4, github_name: "tamarhershi"}
]

cohort_4.each do |stud|
  Student.create(stud)
end

repos = [
  { cohort_num: 4, repo_url: "Ada-C4/TaskListRails"},
  { cohort_num: 4, repo_url: "Ada-C4/SinatraSite"}
]

repos.each do |repo|
  Repo.create(repo)
end
