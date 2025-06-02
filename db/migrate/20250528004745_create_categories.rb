class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :stay_time
      t.timestamps
    end
    Category.create!(name: "sightseeing", stay_time: 90)
    Category.create!(name: "shopping", stay_time: 60)
    Category.create!(name: "leisure_land", stay_time: 300)
    Category.create!(name: "nature", stay_time: 50)
    Category.create!(name: "restaurant", stay_time: 60)
    Category.create!(name: "another")
  end
end
