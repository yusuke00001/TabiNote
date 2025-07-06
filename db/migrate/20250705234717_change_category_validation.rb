class ChangeCategoryValidation < ActiveRecord::Migration[8.0]
  def up
    change_column :categories, :name, :string, null: false
    change_column :categories, :stay_time, :integer, null: false
  end

  def down
    change_column :categories, :name, :string, null: true
    change_column :categories, :stay_time, :integer, null: true
  end
end
