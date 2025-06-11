class CreatePlanSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_spots do |t|
      t.timestamps
      t.integer :order
      t.integer :duration
      t.references :spot, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :plan, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
