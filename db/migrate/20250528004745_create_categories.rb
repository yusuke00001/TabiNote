class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, unique: true
      t.integer :stay_time
      t.timestamps
    end
  end
end
