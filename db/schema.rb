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

ActiveRecord::Schema.define(version: 20131003174811) do

  create_table "commits", force: true do |t|
    t.integer  "user_id",           null: false
    t.integer  "repo_id",           null: false
    t.string   "sha",               null: false
    t.string   "message",           null: false
    t.string   "exercise_dirs_csv", null: false
    t.datetime "committed_at",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commits", ["committed_at"], name: "index_commits_on_committed_at"
  add_index "commits", ["sha"], name: "index_commits_on_sha", unique: true

  create_table "exercises", force: true do |t|
    t.string   "dir_name",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercises", ["dir_name"], name: "index_exercises_on_dir_name"

  create_table "lesson_plans", force: true do |t|
    t.date     "date",        null: false
    t.text     "content",     null: false
    t.string   "topic",       null: false
    t.string   "handout_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refreshes", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "repo_id",     null: false
    t.integer  "exercise_id", null: false
    t.datetime "logged_at",   null: false
  end

  add_index "refreshes", ["exercise_id"], name: "index_refreshes_on_exercise_id"
  add_index "refreshes", ["repo_id"], name: "index_refreshes_on_repo_id"
  add_index "refreshes", ["user_id"], name: "index_refreshes_on_user_id"

  create_table "repos", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.string   "https_url",  null: false
    t.integer  "hook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repos", ["https_url"], name: "index_repos_on_https_url", unique: true
  add_index "repos", ["user_id"], name: "index_repos_on_user_id"

  create_table "users", force: true do |t|
    t.string   "github_username", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["github_username"], name: "index_users_on_github_username", unique: true

end
