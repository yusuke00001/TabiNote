class CreatePlanTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_trips do |t|
      t.references :trip, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :plan, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
    add_index :plan_trips, [ :plan_id, :trip_id ], unique: true
  end
end
