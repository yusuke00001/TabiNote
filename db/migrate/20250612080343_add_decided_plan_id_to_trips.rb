class AddDecidedPlanIdToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :decided_plan_id, :bigint
    add_foreign_key :trips, :plans, column: :decided_plan_id, on_update: :cascade
  end
end
