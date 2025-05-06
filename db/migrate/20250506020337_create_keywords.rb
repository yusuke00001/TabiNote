class CreateKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :keywords do |t|
      t.string :word, null: false
      t.timestamps
    end
  end
end
