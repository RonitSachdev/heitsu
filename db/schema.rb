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

ActiveRecord::Schema[8.0].define(version: 2025_07_01_024916) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "status", default: "registered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
    t.index ["user_id", "event_id"], name: "index_event_registrations_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_registrations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.datetime "event_date"
    t.string "category"
    t.string "image"
    t.integer "max_attendees"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.string "role", default: "member"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_members_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "group_swipes", force: :cascade do |t|
    t.bigint "swiper_id", null: false
    t.bigint "group_id", null: false
    t.string "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_swipes_on_group_id"
    t.index ["swiper_id", "group_id"], name: "index_group_swipes_on_swiper_id_and_group_id", unique: true
    t.index ["swiper_id"], name: "index_group_swipes_on_swiper_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "event_id", null: false
    t.bigint "creator_id", null: false
    t.integer "max_members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id"
    t.index ["event_id"], name: "index_groups_on_event_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id"
    t.text "content"
    t.string "message_type"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_messages_on_group_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "user_matches", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_user_matches_on_event_id"
    t.index ["user1_id", "user2_id", "event_id"], name: "index_user_matches_on_user1_user2_event", unique: true
    t.index ["user1_id"], name: "index_user_matches_on_user1_id"
    t.index ["user2_id"], name: "index_user_matches_on_user2_id"
  end

  create_table "user_swipes", force: :cascade do |t|
    t.bigint "swiper_id", null: false
    t.bigint "swiped_user_id", null: false
    t.bigint "event_id", null: false
    t.string "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_user_swipes_on_event_id"
    t.index ["swiped_user_id"], name: "index_user_swipes_on_swiped_user_id"
    t.index ["swiper_id", "swiped_user_id", "event_id"], name: "index_user_swipes_on_swiper_swiped_user_event", unique: true
    t.index ["swiper_id"], name: "index_user_swipes_on_swiper_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "event_registrations", "events"
  add_foreign_key "event_registrations", "users"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "group_swipes", "groups"
  add_foreign_key "group_swipes", "users", column: "swiper_id"
  add_foreign_key "groups", "events"
  add_foreign_key "groups", "users", column: "creator_id"
  add_foreign_key "messages", "groups"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "user_matches", "events"
  add_foreign_key "user_matches", "users", column: "user1_id"
  add_foreign_key "user_matches", "users", column: "user2_id"
  add_foreign_key "user_swipes", "events"
  add_foreign_key "user_swipes", "users", column: "swiped_user_id"
  add_foreign_key "user_swipes", "users", column: "swiper_id"
end
