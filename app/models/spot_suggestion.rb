class SpotSuggestion < ApplicationRecord
  has_many :spot_vote
  belongs_to :user
  belogns_to :trip
  belogns_to :spot
end
