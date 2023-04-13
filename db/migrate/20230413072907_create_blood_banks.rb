class CreateBloodBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :blood_banks do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :location
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
