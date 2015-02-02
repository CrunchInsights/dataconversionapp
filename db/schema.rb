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

ActiveRecord::Schema.define(version: 20150130111004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "11422357488278s", id: false, force: true do |t|
    t.string   "name",         limit: 4,                          null: false
    t.string   "manager",      limit: 4,                          null: false
    t.string   "status",       limit: 13,                         null: false
    t.integer  "terms",                                           null: false
    t.datetime "date",                                            null: false
    t.decimal  "cost",                    precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",            precision: 4, scale: 2, null: false
  end

  create_table "11422528771982s", id: false, force: true do |t|
    t.string   "name",              limit: 4,                          null: false
    t.string   "manager",           limit: 4,                          null: false
    t.string   "status",            limit: 13,                         null: false
    t.integer  "terms",                                                null: false
    t.datetime "date",                                                 null: false
    t.decimal  "cost",                         precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2, null: false
    t.string   "longdatetimevalue", limit: 28
    t.datetime "datetimevalue"
  end

  create_table "11422529354101s", id: false, force: true do |t|
    t.string   "name",              limit: 4,                          null: false
    t.string   "manager",           limit: 4,                          null: false
    t.string   "status",            limit: 13,                         null: false
    t.integer  "terms",                                                null: false
    t.datetime "date",                                                 null: false
    t.decimal  "cost",                         precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2, null: false
    t.string   "longdatetimevalue", limit: 28
    t.datetime "datetimevalue"
  end

  create_table "11422529930651s", id: false, force: true do |t|
    t.string   "name",              limit: 2,                          null: false
    t.string   "manager",           limit: 3,                          null: false
    t.string   "status",            limit: 5,                          null: false
    t.integer  "terms",                                                null: false
    t.datetime "date",                                                 null: false
    t.decimal  "cost",                         precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                                null: false
    t.boolean  "bool2",                                                null: false
    t.boolean  "bool3",                                                null: false
    t.decimal  "averageprice",                 precision: 4, scale: 2, null: false
    t.string   "longdatetimevalue", limit: 28,                         null: false
    t.datetime "datetimevalue",                                        null: false
  end

  add_index "11422529930651s", ["longdatetimevalue"], name: "index_11422529930651s_on_longdatetimevalue", unique: true, using: :btree
  add_index "11422529930651s", ["manager"], name: "index_11422529930651s_on_manager", unique: true, using: :btree
  add_index "11422529930651s", ["name"], name: "index_11422529930651s_on_name", unique: true, using: :btree
  add_index "11422529930651s", ["status"], name: "index_11422529930651s_on_status", unique: true, using: :btree
  add_index "11422529930651s", ["terms"], name: "index_11422529930651s_on_terms", unique: true, using: :btree

  create_table "11422530643811s", id: false, force: true do |t|
    t.string   "name",              limit: 2,                         null: false
    t.string   "manager",           limit: 3,                         null: false
    t.string   "status",            limit: 5,                         null: false
    t.datetime "terms",                                               null: false
    t.datetime "date",                                                null: false
    t.decimal  "cost",                        precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                               null: false
    t.boolean  "bool2",                                               null: false
    t.boolean  "bool3",                                               null: false
    t.decimal  "averageprice",                precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue",                                   null: false
    t.datetime "datetimevalue",                                       null: false
  end

  add_index "11422530643811s", ["manager"], name: "index_11422530643811s_on_manager", unique: true, using: :btree
  add_index "11422530643811s", ["name"], name: "index_11422530643811s_on_name", unique: true, using: :btree
  add_index "11422530643811s", ["status"], name: "index_11422530643811s_on_status", unique: true, using: :btree

  create_table "11422532278765s", id: false, force: true do |t|
    t.string   "name",              limit: 4,                          null: false
    t.string   "manager",           limit: 4,                          null: false
    t.string   "status",            limit: 13,                         null: false
    t.integer  "terms",                                                null: false
    t.datetime "date",                                                 null: false
    t.decimal  "cost",                         precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
  end

  create_table "11422532411456s", id: false, force: true do |t|
    t.string   "name",              limit: 2
    t.string   "manager",           limit: 3
    t.string   "status",            limit: 5
    t.datetime "terms"
    t.datetime "date"
    t.decimal  "cost",                         precision: 3, scale: 1
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "column13",          limit: 10
  end

  add_index "11422532411456s", ["manager"], name: "index_11422532411456s_on_manager", unique: true, using: :btree
  add_index "11422532411456s", ["name"], name: "index_11422532411456s_on_name", unique: true, using: :btree
  add_index "11422532411456s", ["status"], name: "index_11422532411456s_on_status", unique: true, using: :btree

  create_table "11422532984910s", id: false, force: true do |t|
    t.string   "name",              limit: 2
    t.string   "manager",           limit: 3
    t.string   "status",            limit: 5
    t.datetime "terms"
    t.datetime "date"
    t.decimal  "cost",                         precision: 3, scale: 1
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "column13",          limit: 10
  end

  add_index "11422532984910s", ["manager"], name: "index_11422532984910s_on_manager", unique: true, using: :btree
  add_index "11422532984910s", ["name"], name: "index_11422532984910s_on_name", unique: true, using: :btree
  add_index "11422532984910s", ["status"], name: "index_11422532984910s_on_status", unique: true, using: :btree

  create_table "11422533266043s", id: false, force: true do |t|
    t.string   "name",              limit: 2
    t.string   "manager",           limit: 3
    t.string   "status",            limit: 5
    t.datetime "terms"
    t.datetime "date"
    t.decimal  "cost",                         precision: 3, scale: 1
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "column13",          limit: 10
  end

  add_index "11422533266043s", ["manager"], name: "index_11422533266043s_on_manager", unique: true, using: :btree
  add_index "11422533266043s", ["name"], name: "index_11422533266043s_on_name", unique: true, using: :btree
  add_index "11422533266043s", ["status"], name: "index_11422533266043s_on_status", unique: true, using: :btree

  create_table "11422534001097s", id: false, force: true do |t|
    t.string   "name",              limit: 2
    t.string   "manager",           limit: 3
    t.string   "status",            limit: 5
    t.datetime "terms"
    t.datetime "date"
    t.decimal  "cost",                         precision: 3, scale: 1
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "column13",          limit: 10
  end

  add_index "11422534001097s", ["manager"], name: "index_11422534001097s_on_manager", unique: true, using: :btree
  add_index "11422534001097s", ["name"], name: "index_11422534001097s_on_name", unique: true, using: :btree
  add_index "11422534001097s", ["status"], name: "index_11422534001097s_on_status", unique: true, using: :btree

  create_table "11422534247170s", id: false, force: true do |t|
    t.string   "name",              limit: 2,                         null: false
    t.string   "manager",           limit: 3,                         null: false
    t.string   "status",            limit: 5,                         null: false
    t.datetime "terms",                                               null: false
    t.datetime "date",                                                null: false
    t.decimal  "cost",                        precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                               null: false
    t.boolean  "bool2",                                               null: false
    t.boolean  "bool3",                                               null: false
    t.decimal  "averageprice",                precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue",                                   null: false
    t.datetime "datetimevalue",                                       null: false
  end

  add_index "11422534247170s", ["manager"], name: "index_11422534247170s_on_manager", unique: true, using: :btree
  add_index "11422534247170s", ["name"], name: "index_11422534247170s_on_name", unique: true, using: :btree
  add_index "11422534247170s", ["status"], name: "index_11422534247170s_on_status", unique: true, using: :btree

  create_table "11422534408452s", id: false, force: true do |t|
    t.string   "name",              limit: 2,                         null: false
    t.string   "manager",           limit: 3,                         null: false
    t.string   "status",            limit: 5,                         null: false
    t.datetime "terms",                                               null: false
    t.datetime "date",                                                null: false
    t.decimal  "cost",                        precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                               null: false
    t.boolean  "bool2",                                               null: false
    t.boolean  "bool3",                                               null: false
    t.decimal  "averageprice",                precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue",                                   null: false
    t.datetime "datetimevalue",                                       null: false
  end

  add_index "11422534408452s", ["manager"], name: "index_11422534408452s_on_manager", unique: true, using: :btree
  add_index "11422534408452s", ["name"], name: "index_11422534408452s_on_name", unique: true, using: :btree
  add_index "11422534408452s", ["status"], name: "index_11422534408452s_on_status", unique: true, using: :btree

  create_table "11422534585014s", id: false, force: true do |t|
    t.string   "name",              limit: 2,                         null: false
    t.string   "manager",           limit: 3,                         null: false
    t.string   "status",            limit: 5,                         null: false
    t.integer  "terms",                                               null: false
    t.datetime "date",                                                null: false
    t.decimal  "cost",                        precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                               null: false
    t.boolean  "bool2",                                               null: false
    t.boolean  "bool3",                                               null: false
    t.decimal  "averageprice",                precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue",                                   null: false
    t.datetime "datetimevalue",                                       null: false
  end

  add_index "11422534585014s", ["manager"], name: "index_11422534585014s_on_manager", unique: true, using: :btree
  add_index "11422534585014s", ["name"], name: "index_11422534585014s_on_name", unique: true, using: :btree
  add_index "11422534585014s", ["status"], name: "index_11422534585014s_on_status", unique: true, using: :btree
  add_index "11422534585014s", ["terms"], name: "index_11422534585014s_on_terms", unique: true, using: :btree

  create_table "11422535038030s", id: false, force: true do |t|
    t.string   "name",              limit: 4,                          null: false
    t.string   "manager",           limit: 4,                          null: false
    t.string   "status",            limit: 13,                         null: false
    t.integer  "terms",                                                null: false
    t.datetime "date",                                                 null: false
    t.decimal  "cost",                         precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                 precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
  end

  create_table "11422535967825s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "11422536061207s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "11422536691572s", id: false, force: true do |t|
    t.string   "name",               limit: 4,                          null: false
    t.string   "manager",            limit: 4,                          null: false
    t.string   "status",             limit: 13,                         null: false
    t.integer  "terms",                                                 null: false
    t.datetime "date",                                                  null: false
    t.decimal  "cost",                          precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                  precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "name1",              limit: 4,                          null: false
    t.string   "manager1",           limit: 4,                          null: false
    t.string   "status1",            limit: 13,                         null: false
    t.integer  "terms1",                                                null: false
    t.datetime "date1",                                                 null: false
    t.decimal  "cost1",                         precision: 6, scale: 4, null: false
    t.boolean  "bool11"
    t.boolean  "bool21"
    t.boolean  "bool31"
    t.decimal  "averageprice1",                 precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue1"
    t.datetime "datetimevalue1"
  end

  create_table "11422614478081s", id: false, force: true do |t|
    t.string   "name",               limit: 4,                          null: false
    t.string   "manager",            limit: 4,                          null: false
    t.string   "status",             limit: 13,                         null: false
    t.integer  "terms",                                                 null: false
    t.datetime "date",                                                  null: false
    t.decimal  "cost",                          precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
    t.decimal  "averageprice",                  precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue"
    t.datetime "datetimevalue"
    t.string   "name1",              limit: 4,                          null: false
    t.string   "manager1",           limit: 4,                          null: false
    t.string   "status1",            limit: 13,                         null: false
    t.integer  "terms1",                                                null: false
    t.datetime "date1",                                                 null: false
    t.decimal  "cost1",                         precision: 6, scale: 4, null: false
    t.boolean  "bool11"
    t.boolean  "bool21"
    t.boolean  "bool31"
    t.decimal  "averageprice1",                 precision: 4, scale: 2, null: false
    t.datetime "longdatetimevalue1"
    t.datetime "datetimevalue1"
  end

  create_table "table_error_records", force: true do |t|
    t.string   "table_name"
    t.integer  "row_id"
    t.string   "error_message"
    t.text     "error_record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_file_mappings", force: true do |t|
    t.integer  "user_id"
    t.string   "file_name",          limit: 100,                 null: false
    t.string   "table_name",         limit: 100,                 null: false
    t.integer  "created_by"
    t.datetime "created_on"
    t.integer  "modified_by"
    t.datetime "modified_on"
    t.boolean  "is_record_uploaded",             default: false
    t.boolean  "is_table_created",               default: false
    t.boolean  "has_error_record",               default: false
  end

  add_index "user_file_mappings", ["table_name"], name: "index_user_file_mappings_on_table_name", unique: true, using: :btree
  add_index "user_file_mappings", ["user_id"], name: "index_user_file_mappings_on_user_id", using: :btree

  create_table "user_table_column_informations", force: true do |t|
    t.string   "table_name"
    t.string   "column_name"
    t.string   "money_format"
    t.boolean  "is_disable"
    t.integer  "created_by"
    t.datetime "created_on"
    t.integer  "modified_by"
    t.datetime "modified_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_percentage_value", default: false
  end

  create_table "users", force: true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
