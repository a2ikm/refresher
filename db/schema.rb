# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_05_141916) do
  create_table "access_tokens", force: :cascade do |t|
    t.integer "session_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expired_at", null: false
    t.index ["session_id"], name: "index_access_tokens_on_session_id"
    t.index ["token"], name: "index_access_tokens_on_token", unique: true
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.integer "session_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expired_at", null: false
    t.datetime "invalidated_at"
    t.index ["session_id"], name: "index_refresh_tokens_on_session_id"
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "access_tokens", "sessions"
  add_foreign_key "refresh_tokens", "sessions"
  add_foreign_key "sessions", "users"
end
