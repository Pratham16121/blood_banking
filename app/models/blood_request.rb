class BloodRequest < ApplicationRecord
  validates :recipent_id, presence: true
  validates :blood_type, presence: true

  enum blood_type: User.blood_types
  
end
