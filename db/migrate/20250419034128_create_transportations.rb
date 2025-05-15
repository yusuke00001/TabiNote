class CreateTransportations < ActiveRecord::Migration[8.0]
  def change
    create_table :transportations do |t|
      t.string :name

      t.timestamps
    end
    Transportation.create(name: "車")
    Transportation.create(name: "電車")
    Transportation.create(name: "自転車")
  end
end
