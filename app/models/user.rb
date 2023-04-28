class User < ApplicationRecord
  has_secure_password
  before_validation :set_role_id

  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'
  has_many :donations, :foreign_key => 'donar_id'
  has_many :blood_banks, through: :donations

  validates :email, presence: true, uniqueness: { scope: :blood_bank_id }
  validates :phone, presence: true, uniqueness: true, format: { with: /[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}/, 
                                                                message: "Invalid phone number format" }
  validates :blood_type, presence: true
  validates :name, presence: true
  validates :sex, format: { with: /\A(Male|Female|Other)\z/,
    message: "only allows 'Male', 'Female' and 'Other" }
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

  def is_super_admin?
    Role.find(self.role_id).name.eql?(Role::ROLE[:super_admin])
  end

  def is_admin?
    Role.find(self.role_id).name.eql?(Role::ROLE[:admin])
  end

  def is_user?
    Role.find(self.role_id).name.eql?(Role::ROLE[:user])
  end

  private

  def set_role_id 
    self.role_id = Role.find_by_name('user').id unless role_id.present?
  end
end
