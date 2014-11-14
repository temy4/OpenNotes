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

ActiveRecord::Schema.define(version: 20130923114132) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "rgb_color"
    t.string   "html_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notepads", force: true do |t|
    t.string   "name"
    t.integer  "typeofnp"
    t.integer  "parent_id",  default: 0
    t.integer  "order",      default: 100
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "note_text"
    t.text     "tags"
    t.integer  "notepad_id"
    t.integer  "category_id"
    t.boolean  "deleted"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "shortcuts", force: true do |t|
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
