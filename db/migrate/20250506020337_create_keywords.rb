class CreateKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :keywords do |t|
      t.string :word, null: false
      t.string :location_name
      t.timestamps
    end
  end
end
