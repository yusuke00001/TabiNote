class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string     :queue_name, null: false
      t.string     :job_class, null: false
      t.text       :arguments
      t.text       :priority
      t.datetime   :scheduled_at
      t.datetime   :finished_at
      t.string     :active_job_id
      t.integer    :attempts, null: false, default: 0
      t.timestamps
    end

    add_index :solid_queue_jobs, :queue_name
    add_index :solid_queue_jobs, :scheduled_at
    add_index :solid_queue_jobs, :active_job_id
  end
end
