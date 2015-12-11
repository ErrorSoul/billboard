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

ActiveRecord::Schema.define(version: 20151211154113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.decimal  "salary",      precision: 10, scale: 2
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "status",                               default: 0
  end

  create_table "skill_items", force: :cascade do |t|
    t.integer "skill_id"
    t.integer "skillable_id"
    t.string  "skillable_type"
  end

  add_index "skill_items", ["skill_id"], name: "index_skill_items_on_skill_id", using: :btree
  add_index "skill_items", ["skillable_type", "skillable_id"], name: "index_skill_items_on_skillable_type_and_skillable_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string "name"
  end

  add_index "skills", ["id", "name"], name: "index_skills_on_id_and_name", unique: true, using: :btree
  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree

  create_table "vacancies", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.decimal  "salary",       precision: 10, scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "published_at"
    t.integer  "validity"
    t.string   "state"
  end

  add_index "vacancies", ["email"], name: "index_vacancies_on_email", using: :btree
  add_index "vacancies", ["phone"], name: "index_vacancies_on_phone", using: :btree

  add_foreign_key "skill_items", "skills"
end
