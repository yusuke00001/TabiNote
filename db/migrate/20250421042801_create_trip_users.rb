class CreateTripUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_users do |t|
      t.integer :host
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :trip, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end
end
