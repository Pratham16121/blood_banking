class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.integer :donar_id, foreign_key: {to_table: :users}
      t.integer :blood_type
      t.integer :blood_unit

      t.timestamps
    end
  end
end
