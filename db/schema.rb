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

ActiveRecord::Schema.define(:version => 20140213014948) do

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
    t.boolean  "page_editor",            :default => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "airdata_airoptions", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "airdata_airports", :force => true do |t|
    t.string   "icao"
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.integer  "elevation"
    t.integer  "ta"
    t.integer  "msa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "airdata_runways", :force => true do |t|
    t.integer  "airport_id"
    t.string   "number"
    t.integer  "course"
    t.integer  "length"
    t.boolean  "ils"
    t.float    "ils_freq"
    t.integer  "ils_fac"
    t.float    "lat"
    t.float    "lon"
    t.integer  "elevation"
    t.float    "glidepath"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "airdata_waypoints", :force => true do |t|
    t.string   "ident"
    t.string   "name"
    t.float    "freq"
    t.float    "lat"
    t.float    "lon"
    t.integer  "range"
    t.integer  "elevation"
    t.string   "country_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "airports", :force => true do |t|
    t.string   "icao"
    t.integer  "country_id"
    t.boolean  "major",            :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "scenery_fs9_link"
    t.string   "scenery_fsx_link"
    t.string   "scenery_xp_link"
    t.string   "iata"
    t.text     "description"
  end

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

  create_table "atc_bookings", :force => true do |t|
    t.string   "controller"
    t.string   "position"
    t.datetime "starts"
    t.datetime "ends"
    t.integer  "admin_user_id"
    t.integer  "eu_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "eud",                  :default => false
    t.integer  "subdivision_id"
    t.integer  "frequency_country_id"
  end

  create_table "custom_chart_sources", :force => true do |t|
    t.integer  "subdivision_id"
    t.string   "url"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "custom_charts", :force => true do |t|
    t.string   "icao"
    t.string   "name"
    t.string   "url"
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
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "vaccs"
    t.boolean  "weekly",      :default => false
    t.string   "weekly_hash"
  end

  create_table "events_subdivisions", :force => true do |t|
    t.integer "event_id"
    t.integer "subdivision_id"
  end

  create_table "individual_custom_charts", :force => true do |t|
    t.string   "icao"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "layouts", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mass_bookings", :force => true do |t|
    t.integer  "admin_user_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "csv_file_file_name"
    t.string   "csv_file_content_type"
    t.integer  "csv_file_file_size"
    t.datetime "csv_file_updated_at"
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
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "humanized_atc_rating"
    t.string   "humanized_pilot_rating"
    t.integer  "pilot_rating"
    t.integer  "rating"
    t.boolean  "active",                 :default => true
  end

  create_table "mercury_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "post",        :default => "Edit here!"
    t.boolean  "published",   :default => true
    t.integer  "author_id"
    t.text     "description", :default => "VATSIM European Division News"
    t.string   "keywords",    :default => "vatsim, vateud, news, simulation, flight, atc, vateur"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "post",        :default => "Edit here!"
    t.text     "sidebar",     :default => "Edit here!"
    t.string   "slug"
    t.text     "description", :default => "VATSIM European Division"
    t.string   "keywords",    :default => "vatsim, vateud, simulation, flight, atc, vateur"
    t.boolean  "abstract",    :default => false
    t.boolean  "visible",     :default => true
    t.boolean  "menu",        :default => true
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.string   "name"
    t.integer  "layout_id"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

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

  create_table "rich_rich_files", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        :default => "file"
  end

  create_table "staff_members", :force => true do |t|
    t.string   "vacc_code"
    t.string   "callsign"
    t.integer  "cid"
    t.string   "email"
    t.string   "position"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "priority"
    t.boolean  "vateud_confirmed", :default => false
  end

  create_table "subdivisions", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "website"
    t.text     "introtext"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "hidden",              :default => false
    t.boolean  "official",            :default => true
    t.string   "frequency_countries"
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
