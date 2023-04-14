class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  ROLE = { super_admin: "super_admin", admin: "admin", user: "user" }
end
