class Consumption < ApplicationRecord
  validates :blood_unit, presence: true
  validates :recipent_id, presence: true
  validates :blood_request_id, presence: true
end
