class SpotVote < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :spot_suggestion
end
