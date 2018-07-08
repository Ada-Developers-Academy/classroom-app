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

ActiveRecord::Schema.define(version: 2018_01_11_181821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instructor_emails"
    t.index ["number", "name"], name: "index_cohorts_on_number_and_name", unique: true
  end

  create_table "cohorts_repos", id: :serial, force: :cascade do |t|
    t.integer "cohort_id", null: false
    t.string "repo_id", null: false
    t.index ["cohort_id", "repo_id"], name: "index_cohorts_repos_on_cohort_id_and_repo_id", unique: true
  end

  create_table "repos", id: :serial, force: :cascade do |t|
    t.string "repo_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "individual", default: true
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "cohort_id", null: false
    t.string "github_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["cohort_id", "github_name"], name: "index_students_on_cohort_id_and_github_name", unique: true
  end

  create_table "submissions", id: :serial, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "repo_id", null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pr_url"
    t.string "feedback_url"
    t.integer "user_id"
    t.enum "grade"
    t.index ["student_id", "repo_id"], name: "index_submissions_on_student_id_and_repo_id", unique: true
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "user_invites", id: :serial, force: :cascade do |t|
    t.integer "inviter_id", null: false
    t.string "github_name", null: false
    t.string "role", default: "unknown", null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cohort_id"
    t.index ["github_name"], name: "index_user_invites_on_github_name", unique: true, where: "(accepted = false)"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "unknown", null: false
    t.text "github_name"
    t.index ["github_name"], name: "index_users_on_github_name", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "submissions", "users"
  add_foreign_key "user_invites", "cohorts", on_delete: :cascade
  add_foreign_key "user_invites", "users", column: "inviter_id", on_delete: :cascade
end
