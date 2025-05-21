class SpotVote < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :spot_suggestion

  def self.register(trip_id:, suggestion_ids:, user_id:)
    transaction do
      Array(suggestion_ids).each do |suggestion_id|
        SpotVote.create!(
          trip_id: trip_id,
          spot_suggestion_id: suggestion_id,
          user_id: user_id
        )
      end
    end
  end
end
