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

ActiveRecord::Schema.define(version: 20140212141950) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "game_id"
    t.boolean  "was_correct"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["game_id"], name: "index_answers_on_game_id"
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id"

  create_table "courses", force: true do |t|
    t.string   "title"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "courses", ["level_id"], name: "index_courses_on_level_id"

  create_table "games", force: true do |t|
    t.integer  "score",      default: 0
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trivia_id"
  end

  add_index "games", ["trivia_id"], name: "index_games_on_trivia_id"
  add_index "games", ["user_id"], name: "index_games_on_user_id"

  create_table "institutes", force: true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "email"
    t.string   "phone"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutes", ["city_id"], name: "index_institutes_on_city_id"

  create_table "levels", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text     "description"
    t.integer  "dificulty"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "incorrect_answer_one"
    t.string   "incorrect_answer_two"
    t.string   "incorrect_answer_three"
    t.string   "incorrect_answer_four"
    t.integer  "trivia_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "questions", ["trivia_id"], name: "index_questions_on_trivia_id"

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.text     "description"
    t.integer  "city_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "teachers", ["city_id"], name: "index_teachers_on_city_id"
  add_index "teachers", ["confirmation_token"], name: "index_teachers_on_confirmation_token", unique: true
  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true

  create_table "trivium", force: true do |t|
    t.string   "title"
    t.text     "tag"
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type"
    t.integer  "teacher_id"
  end

  add_index "trivium", ["course_id"], name: "index_trivium_on_course_id"
  add_index "trivium", ["teacher_id"], name: "index_trivium_on_teacher_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "group"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "last_name"
    t.integer  "level_id"
    t.integer  "institute_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["institute_id"], name: "index_users_on_institute_id"
  add_index "users", ["level_id"], name: "index_users_on_level_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
