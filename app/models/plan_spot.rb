class PlanSpot < ApplicationRecord
  belongs_to :spot
  belongs_to :plan

  def self.plan_spots_create(routes:, spots_in_vote_order:, spot_distance:, trip:)
    routes.each_with_index do |route, index|
      plan = Plan.create!(trip_id: trip.id, title: index + 1)
      ordered_spots = route.map { |i| spots_in_vote_order[i] }
      durations = Spot.move_time_between_spots(combination: route, spot_distance: spot_distance)
      plan_spots_insert_all_data = self.create_plan_spots_insert_all_data(ordered_spots: ordered_spots, durations: durations, plan: plan)
      self.insert_all(plan_spots_insert_all_data)
    end
  end

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
