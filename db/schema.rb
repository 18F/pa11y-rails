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


ActiveRecord::Schema.define(version: 20160316202633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issues", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "github_id"
  end

  add_index "issues", ["site_id"], name: "index_issues_on_site_id", using: :btree

  create_table "orgs", force: :cascade do |t|
    t.string   "title"
    t.string   "github_user"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pa11y_issues", force: :cascade do |t|
    t.integer  "page_id"
    t.text     "description"
    t.string   "code"
    t.string   "css"
    t.text     "element"
    t.string   "issue_type"
    t.boolean  "ignore"
    t.boolean  "fixed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pa11y_issues", ["page_id"], name: "index_pa11y_issues_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "site_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "acc_warnings"
    t.integer  "acc_errors"
    t.integer  "acc_notices"
    t.text     "scan"
    t.integer  "acc_ignore"
    t.integer  "acc_errors_fixed"
  end

  add_index "pages", ["site_id"], name: "index_pages_on_site_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "scan"
    t.integer  "acc_warnings"
    t.integer  "acc_errors"
    t.integer  "acc_notices"
    t.string   "github_user"
    t.string   "github_repo"
    t.integer  "acc_errors_fixed"
    t.integer  "pages_count"
  end

  add_foreign_key "issues", "sites"
  add_foreign_key "pa11y_issues", "pages"
  add_foreign_key "pages", "sites"
end
