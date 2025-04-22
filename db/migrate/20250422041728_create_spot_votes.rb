class CreateSpotVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :spot_votes do |t|
      t.datetime :deadline
      t.references :spot_suggestion, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :trip, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end
end
