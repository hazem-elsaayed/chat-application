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

ActiveRecord::Schema[7.1].define(version: 2024_06_08_121108) do
  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.integer "chats_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_applications_on_token", unique: true
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "chat_number"
    t.integer "messages_count", default: 0
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["application_id", "chat_number"], name: "index_chats_on_application_id_and_chat_number"
    t.index ["application_id"], name: "index_chats_on_application_id"
    t.index ["chat_number"], name: "index_chats_on_chat_number", unique: true
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content", null: false
    t.string "sender", null: false
    t.integer "message_number"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "message_number"], name: "index_messages_on_chat_id_and_message_number"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["message_number"], name: "index_messages_on_message_number", unique: true
  end

  add_foreign_key "chats", "applications"
  add_foreign_key "messages", "chats"
end
