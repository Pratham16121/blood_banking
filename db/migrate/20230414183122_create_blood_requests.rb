class CreateBloodRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :blood_requests do |t|
      t.integer :recipent_id, foreign_key: {to_table: :users}
      t.integer :blood_type
      t.boolean :is_completed, default: :false

      t.timestamps
    end
  end
end
