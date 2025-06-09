class CreateTransportations < ActiveRecord::Migration[8.0]
  def change
    create_table :transportations do |t|
      t.string :name, unique: true
      t.timestamps
    end
  end
end
