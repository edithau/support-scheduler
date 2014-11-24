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

ActiveRecord::Schema.define(:version => 20141118213409) do

  create_table "assignments", :force => true do |t|
    t.integer "user_id"
    t.date    "date"
  end

  add_index "assignments", ["date"], :name => "index_assignments_on_date", :unique => true

  create_table "support_calendars", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string "name",          :limit => 30, :null => false
    t.date   "undoable_date"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
