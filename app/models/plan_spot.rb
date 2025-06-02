class PlanSpot < ApplicationRecord
  belongs_to :plan
  belongs_to :spot

  validates :plan_id, uniqueness: { scope: :spot_id }

  def self.create_plan_spots(plan_id:, spot_ids:)
    Array(spot_ids).each do |spot_id|
      create!(plan_id: plan_id, spot_id: spot_id)
    end
  end
end
