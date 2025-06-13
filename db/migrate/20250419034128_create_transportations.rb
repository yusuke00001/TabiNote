class CreateTransportations < ActiveRecord::Migration[8.0]
  def change
    create_table :transportations do |t|
      t.string :name
      t.timestamps
    end
    add_index :transportations, :name, unique: :true
  end
end
