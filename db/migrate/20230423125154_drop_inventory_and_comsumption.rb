class DropInventoryAndComsumption < ActiveRecord::Migration[7.0]
  def up
    drop_table :inventories
    drop_table :consumptions
  end

  def down
    create_table :inventories do |t|
      t.integer :blood_type
      t.integer :quantity
      t.integer :updated_by, foreign_key: {to_table: :users}
      t.integer :blood_bank_id, foreign_key:{to_table: :blood_banks}
      t.timestamps
    end

    create_table :consumptions do |t|
      t.integer :recipent_id, foreign_key: {to_table: :users}
      t.integer :blood_request_id, foreign_key: {to_table: :blood_requests}
      t.integer :blood_unit
      t.timestamps
    end
  end
end
