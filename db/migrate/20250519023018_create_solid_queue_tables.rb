class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :job_class, null: false
      t.datetime :scheduled_at, precision: nil
      t.datetime :finished_at, precision: nil
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.timestamps
    end

    add_index :solid_queue_jobs, :queue_name
    add_index :solid_queue_jobs, :scheduled_at
    add_index :solid_queue_jobs, :finished_at
  end
end
