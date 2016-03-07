# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create Cohort 4 students
cohort_4 = [
  { name: "Amy", cohort_num: 4, github_name: "lacuchilla"},
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

cohort_5 = [
  { name: "Adriana", cohort_num: 5, github_name: "dri19tcc"},
  { name: "Alysia", cohort_num: 5, github_name: "abrown152"},
  { name: "Ania", cohort_num: 5, github_name: "aniagonzalez"},
  { name: "Anna", cohort_num: 5, github_name: "annamw77"},
  { name: "Cristal", cohort_num: 5, github_name: "bluecolorpencils"},
  { name: "Deirdre", cohort_num: 5, github_name: "dstorck"},
  { name: "Jade", cohort_num: 5, github_name: "jadevance"},
  { name: "Jessica", cohort_num: 5, github_name: "jweeber"},
  { name: "Jillian", cohort_num: 5, github_name: "jboshart"},
  { name: "Justine", cohort_num: 5, github_name: "justinewinnie"},
  { name: "Leah", cohort_num: 5, github_name: "leahnp"},
  { name: "Lisa", cohort_num: 5, github_name: "lisa-sano"},
  { name: "Melissa", cohort_num: 5, github_name: "melissajimison"},
  { name: "Mindy", cohort_num: 5, github_name: "mcarson1111"},
  { name: "Nadine", cohort_num: 5, github_name: "nlcurry"},
  { name: "Nicole", cohort_num: 5, github_name: "nicosaki"},
  { name: "Risha", cohort_num: 5, github_name: "rishallen"},
  { name: "Rowan", cohort_num: 5, github_name: "cotarg"},
  { name: "Sarah K", cohort_num: 5, github_name: "pottery123"},
  { name: "Sarah R", cohort_num: 5, github_name: "nahmisa"},
  { name: "Sophia", cohort_num: 5, github_name: "sophiabaldonado"},
  { name: "Suzanne", cohort_num: 5, github_name: "suzharrison"},
  { name: "Valerie", cohort_num: 5, github_name: "vconklin"},
  { name: "Yordanos", cohort_num: 5, github_name: "yordanosd"}
]

cohort_5.each do |stud|
  Student.create(stud)
end

repos = [
  { cohort_num: 4, repo_url: "Ada-C4/TaskListRails"},
  { cohort_num: 4, repo_url: "Ada-C4/SinatraSite"},
  { cohort_num: 5, repo_url: "Ada-C5/Scrabble"},
  { cohort_num: 5, repo_url: "Ada-C5/BankAccounts"}
]

repos.each do |repo|
  Repo.create(repo)
end
