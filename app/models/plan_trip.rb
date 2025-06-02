class PlanTrip < ApplicationRecord
  belongs_to :plan
  belongs_to :trip

  validates :plan_id, uniqueness: { scope: :trip_id }

  def self.create_plan_trips(plan_id:, trip_id:)
    create!(plan_id: plan_id, trip_id: trip_id)
  end
end
