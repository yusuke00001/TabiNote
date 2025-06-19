class SpotSuggestion < ApplicationRecord
  has_many :spot_vote
  belongs_to :user
  belongs_to :trip
  belongs_to :spot

  validates :trip_id, uniqueness: { scope: :spot_id }

  def created_by?(current_user)
    self.user_id == current_user.id
  end

  def current_user_voted?(current_user_voted_spot_suggestions)
    current_user_voted_spot_suggestions.include?(self.id)
  end

  def self.voted_result(trip:, ng_spot:)
    trip.spot_suggestions.reject { |spot| ng_spot.include?(spot.id) }
  end
end
