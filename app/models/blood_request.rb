class BloodRequest < ApplicationRecord
  belongs_to :recipent, :class_name => 'User', :foreign_key => 'recipent_id' 
  belongs_to :blood_bank

  validates :recipent_id, presence: true
  validates :blood_type, presence: true
  validates :blood_unit, presence: true

  enum blood_type: User.blood_types

end
