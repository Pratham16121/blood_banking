class BloodRequest < ApplicationRecord
  validates :recipent_id, presence: true
  validates :blood_type, presence: true
  validates :blood_unit, presence: true

  enum blood_type: User.blood_types

  after_update :create_consumption, if: :is_completed?

  def create_consumption
    Consumption.create(recipent_id: recipent_id,
                       blood_request_id: id,
                       blood_unit: blood_unit,
                       blood_bank_id: blood_bank_id)
  end
  
end
