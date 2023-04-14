class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.integer :blood_type
      t.integer :quantity
      t.integer :updated_by, foreign_key: {to_table: :users}
      t.integer :blood_bank_id, foreign_key:{to_table: :blood_banks}

      t.timestamps
    end
  end
end
