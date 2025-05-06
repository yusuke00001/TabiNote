class AddCreatorIdToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :created_user_id, :bigint, null: false
    add_foreign_key :trips, :users, column: :created_user_id, on_update: :cascade, on_delete: :cascade
  end
end
