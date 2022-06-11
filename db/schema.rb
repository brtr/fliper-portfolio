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

ActiveRecord::Schema.define(version: 2022_06_04_071514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flipers", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nft_flip_records", force: :cascade do |t|
    t.integer "nft_id"
    t.integer "fliper_id"
    t.integer "gap"
    t.string "slug"
    t.string "token_address"
    t.string "token_id"
    t.string "from_address"
    t.string "to_address"
    t.string "txid"
    t.string "fliper_address"
    t.string "bought_coin"
    t.string "sold_coin"
    t.string "image"
    t.string "permalink"
    t.decimal "sold"
    t.decimal "bought"
    t.decimal "revenue"
    t.decimal "roi"
    t.decimal "bought_usd"
    t.decimal "sold_usd"
    t.decimal "revenue_usd"
    t.decimal "roi_usd"
    t.datetime "sold_time"
    t.datetime "bought_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fliper_address"], name: "index_nft_flip_records_on_fliper_address"
    t.index ["fliper_id"], name: "index_nft_flip_records_on_fliper_id"
    t.index ["nft_id", "fliper_id"], name: "index_nft_flip_records_on_nft_id_and_fliper_id"
    t.index ["nft_id"], name: "index_nft_flip_records_on_nft_id"
    t.index ["slug"], name: "index_nft_flip_records_on_slug"
    t.index ["txid"], name: "index_nft_flip_records_on_txid"
  end

  create_table "nfts", force: :cascade do |t|
    t.integer "chain_id"
    t.string "name"
    t.string "opensea_slug"
    t.string "address"
    t.string "banner"
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
