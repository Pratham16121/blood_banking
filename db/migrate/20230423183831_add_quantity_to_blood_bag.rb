class AddQuantityToBloodBag < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_bags, :quantity, :integer
  end
end
