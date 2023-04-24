class AddBloodBankIdToBloodBagAndRemoveInventoryId < ActiveRecord::Migration[7.0]
  def up
    remove_column :blood_bags, :inventory_id
    add_reference :blood_bags, :blood_bank, foreign_key: true
  end

  def down
    remove_column :blood_bags, :blood_bank_id
  end
end
