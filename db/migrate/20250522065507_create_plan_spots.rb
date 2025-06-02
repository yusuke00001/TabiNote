class CreatePlanSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_spots do |t|
      t.references :spot, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :plan, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
    add_index :plan_spots, [ :plan_id, :spot_id ], unique: true
  end
end
