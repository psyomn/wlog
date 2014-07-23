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

ActiveRecord::Schema.define(:version => 20140723025043) do

  create_table "attachments", :force => true do |t|
    t.text   "filename"
    t.text   "given_name"
    t.binary "data"
  end

  create_table "issues", :force => true do |t|
    t.text    "description"
    t.integer "reported_date"
    t.integer "due_date"
    t.integer "status"
    t.integer "timelog"
    t.text    "long_description"
  end

  create_table "key_values", :force => true do |t|
    t.text "key"
    t.text "value"
  end

  create_table "log_entries", :force => true do |t|
    t.text     "description"
    t.datetime "date"
    t.integer  "issue_id"
  end

  create_table "polymorphic_attachments", :force => true do |t|
    t.text    "discriminator"
    t.integer "discriminator_id"
    t.integer "attachment_id"
  end

end
