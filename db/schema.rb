# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_24_005931) do
  create_table "actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type", null: false
    t.integer "block_transaction_id", null: false
    t.json "data", null: false
  end

  create_table "block_transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trans_hash", null: false
    t.string "sender", null: false
    t.string "receiver", null: false
    t.boolean "success", null: false
    t.string "gas_burnt"
    t.string "block_hash"
    t.integer "height"
    t.string "trans_time"
    t.integer "trans_id"
    t.boolean "contains_transfer", null: false
    t.string "transfer_deposit"
    t.index ["trans_hash"], name: "index_block_transactions_on_trans_hash", unique: true
  end

  add_foreign_key "actions", "block_transactions"
end
