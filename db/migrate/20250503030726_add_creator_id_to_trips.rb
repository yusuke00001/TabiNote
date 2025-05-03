class AddCreatorIdToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :creator_id, :bigint, null: false
    add_foreign_key :trips, :users, column: :creator_id, on_update: :cascade, on_delete: :cascade
  end
end
