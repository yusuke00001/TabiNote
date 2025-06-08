class Plan < ApplicationRecord
  has_many :plan_spots
  has_many :spots, through: :plan_spots
  belongs_to :trip
end
