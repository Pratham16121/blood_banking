class BloodRequest < ApplicationRecord
  validates :recipent_id, presence: true
  validates :blood_type, presence: true

  enum blood_type: User.blood_types

  before_create :set_blood_bank_id

  def set_blood_bank_id
    self.blood_bank_id = current_user.blood_bank_id
  end
  
end
