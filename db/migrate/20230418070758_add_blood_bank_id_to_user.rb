class AddBloodBankIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blood_bank_id, :integer, foreign_key:{to_table: :blood_banks}
  end
end
