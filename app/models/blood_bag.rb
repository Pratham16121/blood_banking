class BloodBag < ApplicationRecord
  belongs_to :blood_bank

  before_create :set_expiry_date
  enum blood_type: User.blood_types

  def set_expiry_date
    self.expiry_date = Time.now + 42.days
  end

  def total_blood_bags
    BloodBag.group(:blood_type).count
  end
end
