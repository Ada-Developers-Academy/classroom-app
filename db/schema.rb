# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_25_185737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string "repo_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "individual", default: true
    t.string "name"
    t.date "due_date"
    t.bigint "classroom_id"
    t.index ["classroom_id"], name: "index_assignments_on_classroom_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instructor_emails"
    t.bigint "cohort_id"
    t.index ["cohort_id"], name: "index_classrooms_on_cohort_id"
    t.index ["number", "name"], name: "index_classrooms_on_number_and_name", unique: true
  end

  create_table "cohorts", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "repo_name"
    t.date "class_start_date"
    t.date "class_end_date"
    t.date "internship_start_date"
    t.date "internship_end_date"
    t.date "graduation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name", null: false
    t.string "github_name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.index ["uid"], name: "index_instructors_on_uid", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "name", null: false
    t.integer "classroom_id", null: false
    t.string "github_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "preferred_name"
    t.string "uid"
    t.index ["classroom_id", "github_name"], name: "index_students_on_classroom_id_and_github_name", unique: true
    t.index ["uid"], name: "index_students_on_uid", unique: true
  end

  create_table "students_submissions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_students_submissions_on_student_id"
    t.index ["submission_id"], name: "index_students_submissions_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "assignment_id", null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pr_url"
    t.string "feedback_url"
    t.integer "grade"
    t.bigint "instructor_id"
    t.index ["instructor_id"], name: "index_submissions_on_instructor_id"
  end

  create_table "user_invites", force: :cascade do |t|
    t.integer "inviter_id", null: false
    t.string "github_name", null: false
    t.string "role", default: "unknown", null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "classroom_id"
    t.string "uid"
    t.index ["classroom_id", "uid"], name: "index_user_invites_on_classroom_id_and_uid", unique: true
    t.index ["classroom_id"], name: "index_user_invites_on_classroom_id"
    t.index ["github_name"], name: "index_user_invites_on_github_name", unique: true, where: "(accepted = false)"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "unknown", null: false
    t.text "github_name"
    t.text "oauth_token"
    t.index ["github_name"], name: "index_users_on_github_name", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "classrooms", "cohorts", on_delete: :cascade
  add_foreign_key "submissions", "instructors"
  add_foreign_key "user_invites", "classrooms", on_delete: :cascade
  add_foreign_key "user_invites", "users", column: "inviter_id", on_delete: :cascade
end
