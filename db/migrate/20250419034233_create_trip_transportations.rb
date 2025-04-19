class CreateTripTransportations < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_transportations do |t|
      t.references :trip, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :transportation, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }

      t.timestamps
    end
  end
end
