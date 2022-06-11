class CreateNftFlipRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :nft_flip_records do |t|
      t.integer  :nft_id
      t.integer  :fliper_id
      t.integer  :gap
      t.string   :slug
      t.string   :token_address
      t.string   :token_id
      t.string   :from_address
      t.string   :to_address
      t.string   :txid
      t.string   :fliper_address
      t.string   :bought_coin
      t.string   :sold_coin
      t.string   :image
      t.string   :permalink
      t.decimal  :sold
      t.decimal  :bought
      t.decimal  :revenue
      t.decimal  :roi
      t.decimal  :bought_usd
      t.decimal  :sold_usd
      t.decimal  :revenue_usd
      t.decimal  :roi_usd
      t.datetime :sold_time
      t.datetime :bought_time

      t.timestamps
    end

    add_index :nft_flip_records, :nft_id
    add_index :nft_flip_records, :fliper_id
    add_index :nft_flip_records, :slug
    add_index :nft_flip_records, :fliper_address
    add_index :nft_flip_records, :txid
    add_index :nft_flip_records, [:nft_id, :fliper_id]
  end
end
