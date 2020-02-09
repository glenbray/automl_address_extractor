# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_08_103532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "street_no"
    t.string "street_name"
    t.string "suburb"
    t.string "state"
    t.string "postcode"
    t.decimal "lat"
    t.decimal "lng"
    t.integer "status"
    t.string "nlp_address"
    t.decimal "nlp_confidence"
    t.decimal "mappify_confidence"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["page_id"], name: "index_addresses_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "page_url"
    t.string "html"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_pages_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "url"
    t.integer "pages_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url"], name: "index_sites_on_url"
  end

  add_foreign_key "addresses", "pages"
  add_foreign_key "pages", "sites"
end
