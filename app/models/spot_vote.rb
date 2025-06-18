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

  def self.not_voted_spots(trip)
    voted_spot_suggestion_ids = trip.spot_votes.pluck(:spot_suggestion_id).uniq
    not_voted_spots_suggestion_ids = trip.spot_suggestions.ids - voted_spot_suggestion_ids
    spot_suggestions = SpotSuggestion.where(id: not_voted_spots_suggestion_ids)
    spot_suggestions
  end

  def self.voted_spot_suggestions(trip)
    voted_spot_suggestion_ids = trip.spot_votes.pluck(:spot_suggestion_id).uniq
    spot_suggestions = SpotSuggestion.where(id: voted_spot_suggestion_ids)
    spot_suggestions
  end
end
