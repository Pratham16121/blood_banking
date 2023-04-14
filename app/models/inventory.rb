class Inventory < ApplicationRecord
  validates :blood_type, presence: true
  enum blood_type: {
    "A+": 0,
    "A-": 1,
    "B+": 2,
    "B-": 3,
    "AB+": 4,
    "AB-": 5,
    "O+": 6,
    "O-": 7
  }
end
