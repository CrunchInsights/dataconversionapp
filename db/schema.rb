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

ActiveRecord::Schema.define(version: 20150331085130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "11425031289549s", id: false, force: true do |t|
    t.string  "name",          limit: 7,                         null: false
    t.string  "manager",       limit: 7,                         null: false
    t.string  "status",        limit: 6,                         null: false
    t.integer "terms",                                           null: false
    t.decimal "cost",                    precision: 3, scale: 1, null: false
    t.boolean "bool1",                                           null: false
    t.boolean "bool2",                                           null: false
    t.boolean "bool3",                                           null: false
    t.decimal "averageprice",            precision: 4, scale: 2, null: false
    t.time    "datetimevalue",                                   null: false
    t.time    "percentvalue",                                    null: false
  end

  create_table "11425032243289s", id: false, force: true do |t|
    t.string  "name",          limit: 7,                         null: false
    t.string  "manager",       limit: 7,                         null: false
    t.string  "status",        limit: 6,                         null: false
    t.integer "terms",                                           null: false
    t.decimal "cost",                    precision: 3, scale: 1, null: false
    t.boolean "bool1",                                           null: false
    t.boolean "bool2",                                           null: false
    t.boolean "bool3",                                           null: false
    t.decimal "averageprice",            precision: 4, scale: 2, null: false
    t.time    "datetimevalue",                                   null: false
    t.time    "percentvalue",                                    null: false
  end

  create_table "11425032531208s", id: false, force: true do |t|
    t.string   "name",          limit: 7,                         null: false
    t.string   "manager",       limit: 7,                         null: false
    t.string   "status",        limit: 6,                         null: false
    t.integer  "terms",                                           null: false
    t.decimal  "cost",                    precision: 3, scale: 1, null: false
    t.boolean  "bool1",                                           null: false
    t.boolean  "bool2",                                           null: false
    t.boolean  "bool3",                                           null: false
    t.decimal  "averageprice",            precision: 4, scale: 2, null: false
    t.datetime "datetimevalue",                                   null: false
    t.time     "percentvalue",                                    null: false
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "file_upload_error_messages", force: true do |t|
    t.string   "table_name"
    t.string   "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "month_insert_demo", id: false, force: true do |t|
    t.datetime "time_type"
  end

  create_table "table_error_records", force: true do |t|
    t.string   "table_name"
    t.integer  "row_id"
    t.string   "error_message"
    t.text     "error_record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_insert_demo", id: false, force: true do |t|
    t.time "time_type"
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
    t.string   "file_upload_status"
    t.integer  "total_records"
    t.integer  "success_records"
    t.integer  "error_records"
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
