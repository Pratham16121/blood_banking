class AddBloodBankIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :blood_bank, foreign_key: true
  end
end
