class Plan < ApplicationRecord
  has_many :plan_spots
  has_many :spots, through: :plan_spots
  has_many :plan_trips
  has_many :trips, through: :plan_trips
end
