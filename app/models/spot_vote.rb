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

  def self.voted_spot_suggestion_ids(trip)
    trip.spot_votes.pluck(:spot_suggestion_id).uniq
  end

  def self.not_voted_spot_suggestions(trip)
    not_voted_ids = trip.spot_suggestions.ids - self.voted_spot_suggestion_ids(trip)
    SpotSuggestion.where(id: not_voted_ids)
  end

  def self.voted_spot_suggestions(trip)
    SpotSuggestion.where(id: self.voted_spot_suggestion_ids(trip))
  end
end
