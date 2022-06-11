class CreateNfts < ActiveRecord::Migration[6.1]
  def change
    create_table :nfts do |t|
      t.integer :chain_id
      t.string  :name
      t.string  :opensea_slug
      t.string  :address
      t.string  :banner
      t.string  :logo

      t.timestamps
    end
  end
end
