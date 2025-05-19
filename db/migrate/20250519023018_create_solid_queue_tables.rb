class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    SolidQueue::Migration.new.change
  end
end
