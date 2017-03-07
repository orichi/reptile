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

ActiveRecord::Schema.define(version: 20170307054348) do

  create_table "cat_records", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "count"
    t.string   "paginate_link"
    t.integer  "pages_count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["name"], name: "index_cat_records_on_name", unique: true
  end

  create_table "cookie_infos", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prod_records", force: :cascade do |t|
    t.string   "j_id"
    t.string   "name"
    t.decimal  "price"
    t.string   "spec"
    t.string   "link"
    t.string   "cat_link"
    t.integer  "cat_page"
    t.text     "desc"
    t.string   "version"
    t.integer  "cat_record_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["j_id"], name: "index_prod_records_on_j_id", unique: true
    t.index ["name"], name: "index_prod_records_on_name"
  end

end
