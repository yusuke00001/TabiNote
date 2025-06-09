class CreateGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :genres do |t|
      t.string :name, unique: true
      t.references :category, null: false, foreign_key: { on_update: :cascade }
      t.timestamps
    end
  end
end
