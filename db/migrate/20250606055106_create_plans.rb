class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.timestamps
      t.string :title
      t.references :trip, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
