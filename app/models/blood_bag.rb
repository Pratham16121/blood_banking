class BloodBag < ApplicationRecord
  before_create :set_expiry_date
  enum blood_type: User.blood_types

  def set_expiry_date
    self.expiry_date = Time.now + 42.days
  end

end
