class CreateSpots < ActiveRecord::Migration[8.0]
  def change
    create_table :spots do |t|
      t.string :spot_name
      t.string :unique_number
      t.string :phone_number
      t.string :opening_hours
      t.string :spot_value
      t.text :URL
      t.string :address
      t.text :image_url

      t.timestamps
    end
    add_index :spots, [ :unique_number ], unique: true
  end
end
