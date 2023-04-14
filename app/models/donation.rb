class Donation < ApplicationRecord
  validates :donar_id, presence: true
  validates :blood_type, presence: true
  validates :blood_unit, presence: true

  enum blood_type: User.blood_type
end
