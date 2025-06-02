class CreateGenreSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :genre_spots do |t|
      t.references :spot, null: false, foreign_key: { on_update: :cascade }
      t.references :genres, null: false, foreign_key: { on_update: :cascade }
      t.timestamps
    end
  end
end
