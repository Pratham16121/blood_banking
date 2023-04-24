class ChangeColumnQuantityInInventoryToBloodUnit < ActiveRecord::Migration[7.0]
  def up
    rename_column :inventories, :quantity, :blood_unit
  end

  def down
    rename_column :inventories, :blood_unit, :quantity
  end
end
