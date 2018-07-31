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

ActiveRecord::Schema.define(version: 2018_07_31_185700) do

  create_table "transactions", force: :cascade do |t|
    t.date "posted_on", null: false
    t.string "payee", null: false
    t.string "description", default: "", null: false
    t.string "category", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.boolean "deposit", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_transactions_on_category"
    t.index ["deposit"], name: "index_transactions_on_deposit"
    t.index ["payee"], name: "index_transactions_on_payee"
    t.index ["posted_on"], name: "index_transactions_on_posted_on"
  end

end
