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

ActiveRecord::Schema.define(version: 20151207191906) do

  create_table "accounts", force: :cascade do |t|
    t.string  "account_type", limit: 10,                 null: false
    t.string  "IBAN",         limit: 34,                 null: false
    t.float   "balance",      limit: 24,                 null: false
    t.integer "currency_id",  limit: 4,                  null: false
    t.integer "client_id",    limit: 4,                  null: false
    t.boolean "is_sms",       limit: 1,  default: false, null: false
    t.boolean "is_email",     limit: 1,  default: false, null: false
    t.boolean "is_active",    limit: 1,  default: true,  null: false
    t.boolean "is_deleted",   limit: 1,  default: false, null: false
  end

  add_index "accounts", ["IBAN"], name: "account_number", unique: true, using: :btree
  add_index "accounts", ["account_type"], name: "type_id", using: :btree
  add_index "accounts", ["client_id"], name: "client_id", using: :btree
  add_index "accounts", ["currency_id"], name: "currency_id", using: :btree

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

  create_table "cards", force: :cascade do |t|
    t.integer "account_id",  limit: 4,                            null: false
    t.integer "client_id",   limit: 4,                            null: false
    t.integer "number",      limit: 4,                            null: false
    t.string  "card_type",   limit: 13, default: "Visa Electron", null: false
    t.boolean "is_sms",      limit: 1,  default: false,           null: false
    t.boolean "is_email",    limit: 1,  default: false
    t.integer "cvv",         limit: 4,                            null: false
    t.date    "date_expiry",                                      null: false
  end

  add_index "cards", ["account_id"], name: "account_id", using: :btree
  add_index "cards", ["client_id"], name: "client_id", using: :btree
  add_index "cards", ["cvv"], name: "cvv", using: :btree

  create_table "client_cities", force: :cascade do |t|
    t.string "name", limit: 32, null: false
  end

  create_table "client_credit_goals", force: :cascade do |t|
    t.string "name", limit: 56, null: false
  end

  create_table "client_credits", force: :cascade do |t|
    t.integer "client_id",        limit: 4,                  null: false
    t.integer "credit_id",        limit: 4,                  null: false
    t.date    "begin_date",                                  null: false
    t.integer "sum",              limit: 4,                  null: false
    t.integer "term",             limit: 4,                  null: false
    t.integer "limit_term",       limit: 4,                  null: false
    t.integer "payment_id",       limit: 4,                  null: false
    t.integer "granting_id",      limit: 4,                  null: false
    t.string  "repayment_method", limit: 45,                 null: false
    t.boolean "is_overdue",       limit: 1,  default: false, null: false
    t.boolean "is_closed",        limit: 1,  default: false, null: false
  end

  add_index "client_credits", ["client_id"], name: "client_id", using: :btree
  add_index "client_credits", ["credit_id"], name: "credit_id", using: :btree

  create_table "client_deposits", force: :cascade do |t|
    t.integer "client_id",  limit: 4,                 null: false
    t.integer "deposit_id", limit: 4,                 null: false
    t.date    "date_begin",                           null: false
    t.date    "date_end",                             null: false
    t.boolean "is_closed",  limit: 1, default: false, null: false
  end

  add_index "client_deposits", ["client_id"], name: "client_id", using: :btree
  add_index "client_deposits", ["deposit_id"], name: "deposit_id", using: :btree

  create_table "client_education", force: :cascade do |t|
    t.string "name", limit: 25, null: false
  end

  create_table "client_family_status", force: :cascade do |t|
    t.string "name", limit: 20, null: false
  end

  create_table "client_job_types", force: :cascade do |t|
    t.string "name", limit: 56, null: false
  end

  create_table "client_street_types", force: :cascade do |t|
    t.string "name", limit: 32, null: false
  end

  create_table "client_streets", force: :cascade do |t|
    t.string  "name",    limit: 64, null: false
    t.integer "type_id", limit: 4,  null: false
  end

  add_index "client_streets", ["type_id"], name: "type_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string  "name",                             limit: 42,              null: false
    t.string  "surname",                          limit: 42,              null: false
    t.string  "patronymic",                       limit: 42,              null: false
    t.date    "birth_date",                                               null: false
    t.string  "sex",                              limit: 1,               null: false
    t.integer "family_status_id",                 limit: 4,               null: false
    t.integer "phone_home",                       limit: 4,               null: false
    t.integer "phone_mobile",                     limit: 4,               null: false
    t.integer "phone_work",                       limit: 4,   default: 0
    t.string  "email",                            limit: 56
    t.integer "city_id",                          limit: 4
    t.integer "street_id",                        limit: 4
    t.string  "house",                            limit: 11
    t.integer "block",                            limit: 4
    t.integer "appartment",                       limit: 4
    t.integer "score",                            limit: 4,   default: 0, null: false
    t.string  "passport_series",                  limit: 4,               null: false
    t.integer "passport_number",                  limit: 4,               null: false
    t.string  "passport_identificational_number", limit: 30,              null: false
    t.date    "passport_begin_date",                                      null: false
    t.date    "passport_end_date",                                        null: false
    t.string  "address_living",                   limit: 150,             null: false
    t.string  "address_registration",             limit: 150,             null: false
    t.integer "education_id",                     limit: 4,               null: false
    t.integer "job_type_id",                      limit: 4,               null: false
    t.integer "salary",                           limit: 4,               null: false
    t.integer "user_id",                          limit: 4,   default: 0, null: false
  end

  add_index "clients", ["city_id"], name: "city_id", using: :btree
  add_index "clients", ["education_id"], name: "education_id", using: :btree
  add_index "clients", ["family_status_id"], name: "family_status_id", using: :btree
  add_index "clients", ["house"], name: "house", using: :btree
  add_index "clients", ["job_type_id"], name: "job_type_id", using: :btree
  add_index "clients", ["phone_home"], name: "phone", using: :btree
  add_index "clients", ["score"], name: "score", using: :btree
  add_index "clients", ["street_id"], name: "street_id", using: :btree
  add_index "clients", ["user_id"], name: "user_id", using: :btree

  create_table "contracts", force: :cascade do |t|
    t.string  "file_path",      limit: 100, null: false
    t.string  "operation_type", limit: 16,  null: false
    t.integer "type_id",        limit: 4,   null: false
  end

  add_index "contracts", ["type_id"], name: "type_id", using: :btree

  create_table "credit_applications", force: :cascade do |t|
    t.string   "param_names",    limit: 255
    t.string   "param_values",   limit: 255
    t.string   "application_id", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "credit_granting_types", force: :cascade do |t|
    t.string "name", limit: 45, null: false
  end

  create_table "credit_grantings", force: :cascade do |t|
    t.integer "credit_id",        limit: 4, null: false
    t.integer "granting_type_id", limit: 4, null: false
  end

  add_index "credit_grantings", ["credit_id", "granting_type_id"], name: "credit_id", using: :btree

  create_table "credit_payment_types", force: :cascade do |t|
    t.string "name", limit: 45, null: false
  end

  create_table "credit_payments", force: :cascade do |t|
    t.integer "credit_id",       limit: 4, null: false
    t.integer "payment_type_id", limit: 4, null: false
  end

  add_index "credit_payments", ["credit_id", "payment_type_id"], name: "credit_id", using: :btree

  create_table "credit_states", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "credit_warranty_types", force: :cascade do |t|
    t.string "name", limit: 45, null: false
  end

  create_table "credit_warrenties", force: :cascade do |t|
    t.integer "credit_id",        limit: 4, null: false
    t.integer "warrenty_type_id", limit: 4, null: false
  end

  add_index "credit_warrenties", ["credit_id", "warrenty_type_id"], name: "credit_id", using: :btree

  create_table "credits", force: :cascade do |t|
    t.string  "name",                 limit: 68, null: false
    t.integer "percent",              limit: 4,  null: false
    t.integer "currency_id",          limit: 4,  null: false
    t.integer "default_interest",     limit: 4,  null: false
    t.integer "min_sum",              limit: 4,  null: false
    t.integer "max_sum",              limit: 4,  null: false
    t.integer "min_number_of_months", limit: 4,  null: false
    t.integer "max_number_of_months", limit: 4,  null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", limit: 5, null: false
  end

  create_table "currency_exch_rates", id: false, force: :cascade do |t|
    t.integer "from_currency_id", limit: 4,  null: false
    t.integer "to_currency_id",   limit: 4,  null: false
    t.float   "rate",             limit: 24, null: false
  end

  create_table "deposits", force: :cascade do |t|
    t.string  "name",        limit: 42, null: false
    t.integer "percent",     limit: 4,  null: false
    t.integer "currency_id", limit: 4,  null: false
    t.string  "type",        limit: 16, null: false
    t.integer "duration",    limit: 4,  null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "from",    limit: 42,    null: false
    t.text   "to",      limit: 65535, null: false
    t.text   "message", limit: 65535, null: false
  end

  create_table "online_credits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sms", force: :cascade do |t|
    t.string   "status",    limit: 16,    null: false
    t.integer  "error",     limit: 4,     null: false
    t.text     "message",   limit: 65535, null: false
    t.datetime "timestamp",               null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "name", limit: 16, null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", limit: 42, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string  "name",    limit: 42, null: false
    t.string  "hash",    limit: 32, null: false
    t.string  "salt",    limit: 32, null: false
    t.integer "role_id", limit: 4,  null: false
  end

  add_index "users", ["role_id"], name: "role_id", using: :btree

end
