class ChangeGenreValidation < ActiveRecord::Migration[8.0]
  def change
    change_column :genres, :name, :string, null: false
  end
end
