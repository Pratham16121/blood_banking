class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.integer :age
      t.string :sex
      t.integer :blood_type
      t.text :medical_history
      t.integer :role_id, foreign_key:{to_table: :roles}
      t.timestamps
    end
  end
end
