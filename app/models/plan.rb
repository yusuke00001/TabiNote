class Plan < ApplicationRecord
  has_many :plan_spots
  has_many :spots, through: :plan_spots
  belongs_to :trip

  SIXTY_MINUTES = 60

  def self.plans_display_data_create(plans:, trip:)
    elements = {}
    Array(plans).each do |plan|
      plan.plan_element_create(elements)
    end
    elements
  end

  def plan_element_create(elements)
    elements[self.id] = []
    current_time = self.trip.start_time
    plan_spots = PlanSpot.where(plan_id: self.id).index_by(&:spot_id)
    self.spots.each_with_index do |spot, i|
      if i > 0
        move_duration = self.spots[i - 1].move_duration(self)
        elements[self.id] << {
          time: current_time.strftime("%H:%M"),
          content: move_duration,
          spot_name: spot.spot_name,
          spot_id: spot.id
        }
        current_time += move_duration.minutes
      end
      elements[self.id] << {
        time: current_time.strftime("%H:%M"),
        content: plan_spots[spot.id].stay_time,
        spot_name: spot.spot_name,
        spot_id: spot.id
      }
      current_time += plan_spots[spot.id].stay_time.minutes
    end
    elements[self.id] << {
      time: current_time.strftime("%H:%M"),
      content: "終了"
    }
  end
end
