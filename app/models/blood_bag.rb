class BloodBag < ApplicationRecord
  before_create :set_expiry
  enum blood_type: User.blood_types

  def set_expiry
    self.expiry_date = Time.now + 42.days
  end

end
