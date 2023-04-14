class CreateBloodBags < ActiveRecord::Migration[7.0]
  def change
    create_table :blood_bags do |t|
      t.integer :inventory_id, foreign_key: {to_table: :inventories}
      t.integer :blood_type
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
