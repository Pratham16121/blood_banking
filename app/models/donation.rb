class Donation < ApplicationRecord
  belongs_to :blood_bank
  belongs_to :donar, :class_name => 'User', :foreign_key => 'donar_id'

  validates :donar_id, presence: true
  validates :blood_type, presence: true
  validates :blood_unit, presence: true

  enum blood_type: User.blood_types

  after_create :add_blood_bags

  def add_blood_bags
    byebug
    BloodBag.create!(blood_type: blood_type, expiry_date: Time.current + 42, 
                     blood_bank_id: blood_bank_id, quantity: blood_unit*2)
  end
end
