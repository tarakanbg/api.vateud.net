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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131017135714) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "name"
    t.integer  "vatsimid"
    t.integer  "subdivision_id"
    t.string   "position"
    t.integer  "roles_mask"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "api_calls", :force => true do |t|
    t.string   "endpoint"
    t.string   "parameters"
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "user_agent_version"
    t.string   "user_os"
    t.string   "request_format"
  end

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.string   "vacc_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "chart_overrides", :force => true do |t|
    t.string   "icao"
    t.string   "find_string"
    t.string   "replace_with"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.datetime "starts"
    t.datetime "ends"
    t.string   "banner_url"
    t.text     "description"
    t.string   "airports"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "admin_user_id"
  end

  create_table "members", :force => true do |t|
    t.integer  "cid"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.integer  "age_band"
    t.string   "state"
    t.string   "country"
    t.string   "experience"
    t.string   "susp_ends"
    t.string   "reg_date"
    t.string   "region"
    t.string   "division"
    t.string   "subdivision"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "humanized_atc_rating"
    t.string   "humanized_pilot_rating"
    t.integer  "pilot_rating"
    t.integer  "rating"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "subdivisions", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "website"
    t.text     "introtext"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "vaccs", :force => true do |t|
    t.string   "country"
    t.string   "vacc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "welcome_emails", :force => true do |t|
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
