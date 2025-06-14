class PlanSpot < ApplicationRecord
  belongs_to :spot
  belongs_to :plan

  def self.create_plan_spots_insert_all_data(ordered_spots:, durations:, plan:)
    ordered_spots.each_with_index.map do |spot, index|
      {
        plan_id: plan.id,
        order: index + 1,
        spot_id: spot.id,
        duration: durations[index] || 0
      }
    end
  end
end
