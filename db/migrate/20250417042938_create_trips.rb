class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.timestamps
      t.string :title, null: false
      t.date :date
      t.string :destination, null: false
      t.datetime :start_time, null: false
      t.datetime :finish_time, null: false
      t.integer :status, null: false, default: 0
      t.date :spot_suggestion_limit, null: false
      t.date :spot_vote_limit, null: false
      t.bigint :created_user_id, null: false
      t.bigint :decided_plan_id
    end
    add_foreign_key :trips, :users, column: :created_user_id, on_update: :cascade, on_delete: :cascade
  end
end
