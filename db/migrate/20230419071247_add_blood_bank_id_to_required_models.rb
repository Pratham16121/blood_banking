class AddBloodBankIdToRequiredModels < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_requests, :blood_bank_id, :integer, foreign_key:{to_table: :blood_banks}
    add_column :donations, :blood_bank_id, :integer, foreign_key:{to_table: :blood_banks}
    add_column :consumptions, :blood_bank_id, :integer, foreign_key:{to_table: :blood_banks}
  end
end
