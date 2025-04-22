class SpotSuggestion < ApplicationRecord
  has_many :spot_vote
  belongs_to :user
  belongs_to :trip
  belongs_to :spot
end
