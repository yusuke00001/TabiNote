class CreateSolidQueueTables < ActiveRecord::Migration[7.1] # ← Railsのバージョンに応じて
  def change
    require "solid_queue/database/schema"
    SolidQueue::Database::Schema.new(self).change
  end
end
