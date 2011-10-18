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

ActiveRecord::Schema.define(:version => 20111014154156) do

  create_table "memes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memes", ["name"], :name => "index_memes_on_name", :unique => true

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url",         :limit => 2000
    t.integer  "show_id"
    t.integer  "meme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["meme_id", "show_id"], :name => "index_notes_on_meme_id_and_show_id"
  add_index "notes", ["meme_id"], :name => "index_notes_on_meme_id"
  add_index "notes", ["show_id", "url"], :name => "index_notes_on_show_id_and_url"
  add_index "notes", ["show_id"], :name => "index_notes_on_show_id"

  create_table "shows", :force => true do |t|
    t.integer  "number"
    t.date     "published_date"
    t.boolean  "published"
    t.string   "url",            :limit => 2000
    t.string   "audio_url",      :limit => 2000
    t.string   "cover_art_url",  :limit => 2000
    t.string   "assets_url",     :limit => 2000
    t.string   "show_notes_url", :limit => 2000
    t.text     "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shows", ["number", "published"], :name => "index_shows_on_number_and_published", :unique => true
  add_index "shows", ["number"], :name => "index_shows_on_number", :unique => true
  add_index "shows", ["published_date"], :name => "index_shows_on_published_date"

end
