class AddDecidedPlanIdToTrips < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :trips, :plans, column: :decided_plan_id, on_update: :cascade
  end
end
