# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131006131631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commits", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "repo_id",      null: false
    t.string   "sha",          null: false
    t.string   "message",      null: false
    t.string   "exercise_dir"
    t.integer  "exercise_id"
    t.datetime "committed_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commits", ["committed_at"], name: "index_commits_on_committed_at", using: :btree
  add_index "commits", ["sha"], name: "index_commits_on_sha", using: :btree

  create_table "exercises", id: false, force: true do |t|
    t.integer  "id",             null: false
    t.integer  "lesson_plan_id", null: false
    t.string   "first_line",     null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercises", ["id"], name: "index_exercises_on_id", unique: true, using: :btree
  add_index "exercises", ["lesson_plan_id"], name: "index_exercises_on_lesson_plan_id", using: :btree

  create_table "lesson_plans", force: true do |t|
    t.date     "date",        null: false
    t.text     "content",     null: false
    t.string   "topic",       null: false
    t.string   "handout_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lesson_plans", ["date"], name: "index_lesson_plans_on_date", unique: true, using: :btree

  create_table "refreshes", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "repo_id",      null: false
    t.string   "exercise_dir"
    t.string   "exercise_id"
    t.datetime "logged_at",    null: false
  end

  add_index "refreshes", ["exercise_dir"], name: "index_refreshes_on_exercise_dir", using: :btree
  add_index "refreshes", ["exercise_id"], name: "index_refreshes_on_exercise_id", using: :btree
  add_index "refreshes", ["repo_id"], name: "index_refreshes_on_repo_id", using: :btree
  add_index "refreshes", ["user_id"], name: "index_refreshes_on_user_id", using: :btree

  create_table "repos", force: true do |t|
    t.integer  "user_id",           null: false
    t.string   "name",              null: false
    t.string   "https_url",         null: false
    t.integer  "hook_id"
    t.boolean  "has_exercise_dirs", null: false
    t.boolean  "is_not_found",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repos", ["https_url"], name: "index_repos_on_https_url", unique: true, using: :btree
  add_index "repos", ["user_id"], name: "index_repos_on_user_id", using: :btree

  create_table "sidebar_links", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "github_username", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["github_username"], name: "index_users_on_github_username", unique: true, using: :btree

end
