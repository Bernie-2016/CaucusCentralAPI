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

ActiveRecord::Schema.define(version: 20160217172227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invitations", id: :bigserial, force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "privilege"
    t.integer  "precinct_id"
    t.integer  "state_id"
  end

  add_index "invitations", ["state_id"], name: "index_invitations_on_state_id", using: :btree

  create_table "precincts", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.string   "county"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "total_delegates", default: 0
    t.integer  "state_id"
  end

  add_index "precincts", ["state_id"], name: "index_precincts_on_state_id", using: :btree

  create_table "reports", id: :bigserial, force: :cascade do |t|
    t.integer  "precinct_id"
    t.integer  "user_id"
    t.integer  "source"
    t.string   "aasm_state"
    t.integer  "total_attendees", default: 0
    t.text     "delegate_counts"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "results_counts"
    t.string   "flip_winner"
  end

  create_table "states", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.date     "caucus_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tokens", id: :bigserial, force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "token_type"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "privilege"
    t.integer  "precinct_id"
    t.integer  "invitation_id"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_id"
  end

  add_index "users", ["precinct_id"], name: "index_users_on_precinct_id", using: :btree
  add_index "users", ["state_id"], name: "index_users_on_state_id", using: :btree

end
