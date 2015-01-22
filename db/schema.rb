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

ActiveRecord::Schema.define(version: 20150122110814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book12s", id: false, force: true do |t|
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

  add_index "book12s", ["manager"], name: "index_book12s_on_manager", unique: true, using: :btree
  add_index "book12s", ["name"], name: "index_book12s_on_name", unique: true, using: :btree
  add_index "book12s", ["status"], name: "index_book12s_on_status", unique: true, using: :btree
  add_index "book12s", ["terms"], name: "index_book12s_on_terms", unique: true, using: :btree

  create_table "crunchinsightssampledataset1s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "crunchinsightssampledataset2s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "crunchinsightssampledataset3s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "crunchinsightssampledataset4s", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "crunchinsightssampledatasets", id: false, force: true do |t|
    t.datetime "date",                null: false
    t.string   "browser",   limit: 8, null: false
    t.string   "country",   limit: 8, null: false
    t.boolean  "tutorial",            null: false
    t.boolean  "retainted",           null: false
  end

  create_table "samplecsvtotest12s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest13s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest14s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest15s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest16s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest17s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest18s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest19s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest1s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest20s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest21s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest22s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest23s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest24s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest25s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest26s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest29s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest2s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest30s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest31s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest3s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotest6s", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
  end

  create_table "samplecsvtotests", id: false, force: true do |t|
    t.integer "productsku",                             null: false
    t.integer "date",                                   null: false
    t.integer "quantity",                               null: false
    t.decimal "productrevenue", precision: 8, scale: 2, null: false
    t.decimal "averageprice",   precision: 6, scale: 2, null: false
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
