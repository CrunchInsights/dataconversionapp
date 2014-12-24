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

ActiveRecord::Schema.define(version: 20141216121301) do

  create_table "book11s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book11s", ["manager"], name: "index_book11s_on_manager", unique: true, using: :btree
  add_index "book11s", ["name"], name: "index_book11s_on_name", unique: true, using: :btree
  add_index "book11s", ["status"], name: "index_book11s_on_status", unique: true, using: :btree
  add_index "book11s", ["terms"], name: "index_book11s_on_terms", unique: true, using: :btree

  create_table "book12s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book12s", ["manager"], name: "index_book12s_on_manager", unique: true, using: :btree
  add_index "book12s", ["name"], name: "index_book12s_on_name", unique: true, using: :btree
  add_index "book12s", ["status"], name: "index_book12s_on_status", unique: true, using: :btree
  add_index "book12s", ["terms"], name: "index_book12s_on_terms", unique: true, using: :btree

  create_table "book13s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book13s", ["manager"], name: "index_book13s_on_manager", unique: true, using: :btree
  add_index "book13s", ["name"], name: "index_book13s_on_name", unique: true, using: :btree
  add_index "book13s", ["status"], name: "index_book13s_on_status", unique: true, using: :btree
  add_index "book13s", ["terms"], name: "index_book13s_on_terms", unique: true, using: :btree

  create_table "book14s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book14s", ["manager"], name: "index_book14s_on_manager", unique: true, using: :btree
  add_index "book14s", ["name"], name: "index_book14s_on_name", unique: true, using: :btree
  add_index "book14s", ["status"], name: "index_book14s_on_status", unique: true, using: :btree
  add_index "book14s", ["terms"], name: "index_book14s_on_terms", unique: true, using: :btree

  create_table "book15s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book15s", ["manager"], name: "index_book15s_on_manager", unique: true, using: :btree
  add_index "book15s", ["name"], name: "index_book15s_on_name", unique: true, using: :btree
  add_index "book15s", ["status"], name: "index_book15s_on_status", unique: true, using: :btree
  add_index "book15s", ["terms"], name: "index_book15s_on_terms", unique: true, using: :btree

  create_table "book16s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book16s", ["manager"], name: "index_book16s_on_manager", unique: true, using: :btree
  add_index "book16s", ["name"], name: "index_book16s_on_name", unique: true, using: :btree
  add_index "book16s", ["status"], name: "index_book16s_on_status", unique: true, using: :btree
  add_index "book16s", ["terms"], name: "index_book16s_on_terms", unique: true, using: :btree

  create_table "book17s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book17s", ["manager"], name: "index_book17s_on_manager", unique: true, using: :btree
  add_index "book17s", ["name"], name: "index_book17s_on_name", unique: true, using: :btree
  add_index "book17s", ["status"], name: "index_book17s_on_status", unique: true, using: :btree
  add_index "book17s", ["terms"], name: "index_book17s_on_terms", unique: true, using: :btree

  create_table "book18s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book18s", ["manager"], name: "index_book18s_on_manager", unique: true, using: :btree
  add_index "book18s", ["name"], name: "index_book18s_on_name", unique: true, using: :btree
  add_index "book18s", ["status"], name: "index_book18s_on_status", unique: true, using: :btree
  add_index "book18s", ["terms"], name: "index_book18s_on_terms", unique: true, using: :btree

  create_table "book19s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book19s", ["manager"], name: "index_book19s_on_manager", unique: true, using: :btree
  add_index "book19s", ["name"], name: "index_book19s_on_name", unique: true, using: :btree
  add_index "book19s", ["status"], name: "index_book19s_on_status", unique: true, using: :btree
  add_index "book19s", ["terms"], name: "index_book19s_on_terms", unique: true, using: :btree

  create_table "book1s", force: true do |t|
    t.string   "name",    limit: 4,                          null: false
    t.string   "manager", limit: 4,                          null: false
    t.string   "status",  limit: 13,                         null: false
    t.integer  "terms",   limit: 3,                          null: false
    t.datetime "date",                                       null: false
    t.decimal  "cost",               precision: 6, scale: 4, null: false
    t.boolean  "bool1"
    t.boolean  "bool2"
    t.boolean  "bool3"
  end

  add_index "book1s", ["manager"], name: "index_book1s_on_manager", unique: true, using: :btree
  add_index "book1s", ["name"], name: "index_book1s_on_name", unique: true, using: :btree
  add_index "book1s", ["status"], name: "index_book1s_on_status", unique: true, using: :btree
  add_index "book1s", ["terms"], name: "index_book1s_on_terms", unique: true, using: :btree

  create_table "data_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datauploaders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userfilemappings", force: true do |t|
    t.integer  "user_id"
    t.string   "filename",    null: false
    t.string   "tablename",   null: false
    t.integer  "created_by"
    t.datetime "created_on"
    t.integer  "modified_by"
    t.datetime "modified_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "userfilemappings", ["tablename"], name: "index_userfilemappings_on_tablename", unique: true, using: :btree
  add_index "userfilemappings", ["user_id"], name: "index_userfilemappings_on_user_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
