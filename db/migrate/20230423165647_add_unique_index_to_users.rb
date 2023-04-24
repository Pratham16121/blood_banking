class AddUniqueIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, [:email, :blood_bank_id], unique: true
  end
end
