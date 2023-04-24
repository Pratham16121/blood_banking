class AddBloodBankIdToRequiredModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :blood_requests, :blood_bank, foreign_key: true
    add_reference :donations, :blood_bank, foreign_key: true
    add_reference :consumptions, :blood_bank, foreign_key: true
  end
end
