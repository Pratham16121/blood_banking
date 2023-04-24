class BloodBank < ApplicationRecord
  has_many :blood_bags
  has_many :blood_requests
  has_many :donations
  has_many :users
  has_many :donars, through: :donations, source: :donar

  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :location, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid email format"

end
