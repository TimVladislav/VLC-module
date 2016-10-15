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

ActiveRecord::Schema.define(version: 20161015172654) do

  create_table "devices", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "description",    limit: 255
    t.string   "pic",            limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "html",           limit: 255
    t.string   "style",          limit: 255
    t.string   "basic_script",   limit: 255
    t.string   "buttons_script", limit: 255
    t.string   "buttons_img",    limit: 255
  end

  create_table "devices_labs", id: false, force: :cascade do |t|
    t.integer "device_id", limit: 4
    t.integer "lab_id",    limit: 4
  end

  create_table "labs", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.string   "guide",       limit: 255
    t.integer  "class_study", limit: 4
    t.string   "department",  limit: 255
    t.string   "topic",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "photo",       limit: 255
  end

end
