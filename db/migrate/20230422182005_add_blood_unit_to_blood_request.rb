class AddBloodUnitToBloodRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :blood_requests, :blood_unit, :integer 
  end
end
