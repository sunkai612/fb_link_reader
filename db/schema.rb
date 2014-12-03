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

ActiveRecord::Schema.define(version: 20141201121344) do

  create_table "collections", force: true do |t|
    t.integer  "fb_id"
    t.string   "name"
    t.text     "url"
    t.datetime "fb_created_time"
    t.boolean  "is_read?"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "links", force: true do |t|
    t.text     "url"
    t.text     "name"
    t.datetime "fb_created_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_settings", force: true do |t|
    t.boolean  "show_read?",  default: false
    t.integer  "show_amount", default: 100
    t.integer  "load_amount", default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "subscribed_objs", force: true do |t|
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_links", force: true do |t|
    t.integer  "subscription_id"
    t.integer  "link_id"
    t.integer  "fb_id"
    t.string   "like_count"
    t.string   "comment_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "fb_id"
    t.string   "fb_name"
    t.string   "fb_type"
    t.integer  "belonged_links"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_link_statuses", force: true do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.string   "like_count"
    t.string   "comment_count"
    t.string   "share_count"
    t.text     "publisher"
    t.text     "publish_id"
    t.boolean  "read",          default: false
    t.boolean  "is_page?",      default: false
    t.boolean  "is_ppl?",       default: false
    t.integer  "hot_score"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "token"
    t.datetime "collection_update"
    t.datetime "subscribed_page_update"
    t.datetime "subscribed_ppl_update"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
