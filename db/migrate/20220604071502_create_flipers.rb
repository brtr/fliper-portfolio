class CreateFlipers < ActiveRecord::Migration[6.1]
  def change
    create_table :flipers do |t|
      t.string :address

      t.timestamps
    end
  end
end
