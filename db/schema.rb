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

ActiveRecord::Schema.define(version: 20151024163344) do

  create_table "airlineroutes", force: :cascade do |t|
    t.integer "airline_id", limit: 4, null: false
    t.integer "route_id",   limit: 4, null: false
  end

  create_table "airlines", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "airports", force: :cascade do |t|
    t.string  "name",              limit: 45, null: false
    t.integer "city_id",           limit: 4,  null: false
    t.integer "number_of_runways", limit: 4,  null: false
    t.integer "country_id",        limit: 4,  null: false
  end

  create_table "baggages", force: :cascade do |t|
    t.integer "passenger_id", limit: 4,  null: false
    t.float   "weight",       limit: 24, null: false
  end

  create_table "bank_credit", force: :cascade do |t|
    t.integer "credit_type",                limit: 4
    t.string  "credit_type_another_home",   limit: 255
    t.string  "credit_type_another_car",    limit: 255
    t.string  "credit_type_another_card",   limit: 255
    t.integer "granted_procedure",          limit: 4
    t.integer "affirmation_of_commitments", limit: 4
    t.integer "collateral_customer",        limit: 4
    t.integer "collateral_employee",        limit: 4
    t.integer "score_existance",            limit: 4
    t.integer "account_id",                 limit: 4
  end

  create_table "bank_credits", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "credit_sum",        limit: 4
    t.integer  "credit_term",       limit: 4
    t.integer  "credit_limit_term", limit: 4
    t.integer  "total_income",      limit: 4
    t.integer  "make_insurance",    limit: 4
    t.integer  "repayment_method",  limit: 4
  end

  create_table "cities", force: :cascade do |t|
    t.string  "name",       limit: 45, null: false
    t.integer "country_id", limit: 4,  null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", limit: 45, null: false
  end

  create_table "flights", force: :cascade do |t|
    t.datetime "time_from",                null: false
    t.datetime "time_to",                  null: false
    t.integer  "plane_id",      limit: 4,  null: false
    t.integer  "free_seat",     limit: 4,  null: false
    t.integer  "route_id",      limit: 4,  null: false
    t.integer  "airline_id",    limit: 4,  null: false
    t.string   "flight_number", limit: 45
  end

  create_table "online_credit", force: :cascade do |t|
    t.integer "creditProductType",      limit: 4
    t.integer "currencyType",           limit: 4
    t.integer "sumValue",               limit: 4
    t.integer "termLoanProduct",        limit: 4
    t.integer "provisionType",          limit: 4
    t.text    "otherProvisionType",     limit: 65535
    t.string  "organizationName",       limit: 255
    t.string  "customersAddress",       limit: 255
    t.integer "mainActivityType",       limit: 4
    t.string  "altMainActivity",        limit: 255
    t.integer "organizationExperience", limit: 4
    t.string  "customersFirstname",     limit: 255
    t.string  "customersLastname",      limit: 255
    t.string  "customersPatronymic",    limit: 255
    t.string  "customersPhone",         limit: 255
    t.string  "customersEmail",         limit: 255
  end

  create_table "online_credits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passengers", force: :cascade do |t|
    t.string  "name",            limit: 45, null: false
    t.string  "surname",         limit: 80, null: false
    t.string  "secondname",      limit: 45
    t.integer "country_id",      limit: 4,  null: false
    t.string  "passport_number", limit: 45, null: false
  end

  create_table "planes", force: :cascade do |t|
    t.string  "name",        limit: 45, null: false
    t.string  "plane_class", limit: 45
    t.integer "capacity",    limit: 4,  null: false
  end

  create_table "routes", force: :cascade do |t|
    t.integer "from_airport_id", limit: 4, null: false
    t.integer "to_airport_id",   limit: 4, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.string  "place_number",  limit: 10
    t.integer "passenger_id",  limit: 4,                 null: false
    t.integer "flight_id",     limit: 4,                 null: false
    t.integer "baggage_id",    limit: 4
    t.boolean "ticket_enable", limit: 1,  default: true, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
