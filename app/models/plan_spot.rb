class PlanSpot < ApplicationRecord
  belongs_to :spot
  belongs_to :plan

  def self.plan_spots_create(route:, spots_in_vote_order:, spot_distance:, plan:)
    ordered_spots = route.map { |i| spots_in_vote_order[i] }
    durations = Spot.move_time_between_spots(combination: route, spot_distance: spot_distance)
    plan_spots_insert_all_data = self.create_plan_spots_insert_all_data(ordered_spots: ordered_spots, durations: durations, plan: plan)
    self.insert_all(plan_spots_insert_all_data)
  end

  def self.create_plan_spots_insert_all_data(ordered_spots:, durations:, plan:)
    ordered_spots.each_with_index.map do |spot, index|
      {
        plan_id: plan.id,
        order: index + 1,
        stay_time: spot.category.stay_time,
        spot_id: spot.id,
        duration: durations[index] || 0
      }
    end
  end
end
