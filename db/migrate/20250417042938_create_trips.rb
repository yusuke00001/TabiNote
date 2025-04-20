class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.timestamps
      t.string :title, null: false
      t.date :date
      t.string :distination, null: false
      t.datetime :start_time, null: false
      t.datetime :finish_time, null: false
      t.integer :status, null: false, default: 0
      t.datetime :spot_suggestion_limit, null: false
      t.datetime :spot_vote_limit, null: false
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
