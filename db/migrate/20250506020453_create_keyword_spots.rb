class CreateKeywordSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :keyword_spots do |t|
      t.references :spot, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :keyword, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end
end
