class CreateConsumptions < ActiveRecord::Migration[7.0]
  def change
    create_table :consumptions do |t|
      t.integer :recipent_id, foreign_key: {to_table: :users}
      t.integer :blood_request_id, foreign_key: {to_table: :blood_requests}
      t.integer :blood_unit
      t.timestamps
    end
  end
end
