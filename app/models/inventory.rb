class Inventory < ApplicationRecord
  validates :blood_type, presence: true
  enum blood_type: User.blood_types
end
