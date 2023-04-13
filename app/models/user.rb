class User < ApplicationRecord
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'

  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :blood_type, presence: true
  validates :name, presence: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid email format"
end
