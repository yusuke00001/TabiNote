class CreateTransportations < ActiveRecord::Migration[8.0]
  def change
    create_table :transportations do |t|
      t.boolean :car
      t.boolean :train
      t.boolean :bicycle

      t.timestamps
    end
  end
end
