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

ActiveRecord::Schema[7.0].define(version: 2024_08_29_035218) do
  create_table "histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_histories_on_request_id"
  end

  create_table "lost_utilities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "request_id", null: false
    t.bigint "utility_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_lost_utilities_on_request_id"
    t.index ["utility_id"], name: "index_lost_utilities_on_utility_id"
  end

  create_table "price_fluctuations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.text "reject_reason"
    t.integer "payment"
    t.datetime "paymented_at"
    t.bigint "user_id", null: false
    t.bigint "room_id"
    t.bigint "room_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "history_id"
    t.index ["history_id"], name: "index_requests_on_history_id"
    t.index ["room_id"], name: "index_requests_on_room_id"
    t.index ["room_type_id"], name: "index_requests_on_room_type_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "rate"
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["request_id"], name: "index_reviews_on_request_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "room_costs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "use_date"
    t.bigint "request_id", null: false
    t.bigint "price_fluctuation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_fluctuation_id"], name: "index_room_costs_on_price_fluctuation_id"
    t.index ["request_id"], name: "index_room_costs_on_request_id"
  end

  create_table "room_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "price_weekday"
    t.integer "price_weekend"
    t.integer "area"
    t.integer "number_of_guest_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "room_number"
    t.integer "status"
    t.text "description"
    t.datetime "deleted_at"
    t.bigint "room_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_type_id"], name: "index_rooms_on_room_type_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "utilities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "type"
    t.string "name"
    t.integer "quantity"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "utilities_in_room_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "quantity"
    t.text "description"
    t.bigint "utility_id", null: false
    t.bigint "room_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_type_id"], name: "index_utilities_in_room_types_on_room_type_id"
    t.index ["utility_id"], name: "index_utilities_in_room_types_on_utility_id"
  end

  add_foreign_key "histories", "requests"
  add_foreign_key "lost_utilities", "requests"
  add_foreign_key "lost_utilities", "utilities"
  add_foreign_key "requests", "histories"
  add_foreign_key "requests", "room_types"
  add_foreign_key "requests", "rooms"
  add_foreign_key "requests", "users"
  add_foreign_key "reviews", "requests"
  add_foreign_key "reviews", "users"
  add_foreign_key "room_costs", "price_fluctuations"
  add_foreign_key "room_costs", "requests"
  add_foreign_key "rooms", "room_types"
  add_foreign_key "utilities_in_room_types", "room_types"
  add_foreign_key "utilities_in_room_types", "utilities"
end
