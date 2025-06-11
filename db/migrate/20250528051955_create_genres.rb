class CreateGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :genres do |t|
      t.string :name, null: :false
      t.references :category, null: false, foreign_key: { on_update: :cascade }
      t.timestamps
    end
    add_index :genres, :name, unique: true
  end
end
