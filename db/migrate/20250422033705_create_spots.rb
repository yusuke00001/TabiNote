class CreateSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :spots do |t|
      t.string :spot_name
      t.integer :phone_number
      t.string :opening_hours
      t.string :closing_day
      t.string :genre
      t.string :spot_value
      t.string :other
      t.string :URL
      t.string :stay_time

      t.timestamps
    end
  end
end
