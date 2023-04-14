class User < ApplicationRecord
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'

  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :blood_type, presence: true
  validates :name, presence: true
  validates :sex, format: { with: /\A(male|female|others)\z/,
    message: "only allows 'male', 'female' and 'others" }
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid email format"

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
