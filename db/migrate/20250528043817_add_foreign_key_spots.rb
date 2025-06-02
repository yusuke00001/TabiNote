class AddForeignKeySpots < ActiveRecord::Migration[8.0]
  def change
    add_column :spots, :category_id, :bigint, null: false
    add_foreign_key :spots, :categories, column: :category_id
  end
end
