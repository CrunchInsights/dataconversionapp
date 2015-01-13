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

ActiveRecord::Schema.define(version: 20150113064251) do

  create_table "ss34s", id: false, force: true do |t|
    t.string  "name",    limit: 4,                          null: false
    t.string  "manager", limit: 4,                          null: false
    t.string  "status",  limit: 13,                         null: false
    t.integer "term",                                       null: false
    t.decimal "cost",               precision: 6, scale: 4, null: false
    t.integer "bool1"
    t.integer "bool2"
    t.string  "bool3",   limit: 5
  end

  create_table "user_file_mappings", force: true do |t|
    t.integer  "user_id"
    t.string   "file_name",   limit: 100, null: false
    t.string   "table_name",  limit: 100, null: false
    t.integer  "created_by"
    t.datetime "created_on"
    t.integer  "modified_by"
    t.datetime "modified_on"
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
