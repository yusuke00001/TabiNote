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

  def self.current_user_not_voted_spot_suggestions(trip:, current_user:)
    not_voted_ids = trip.spot_suggestions.ids - self.current_user_voted_spot_suggestions(trip: trip, current_user: current_user)
    SpotSuggestion.where(id: not_voted_ids)
  end

  def self.current_user_voted_spot_suggestions(trip:, current_user:)
    where(trip_id: trip.id, user_id: current_user.id).pluck(:spot_suggestion_id)
  end

  def self.voted_spot_suggestions(trip)
    voted_ids = trip.spot_votes.pluck(:spot_suggestion_id).uniq
    SpotSuggestion.where(id: voted_ids)
  end
end
