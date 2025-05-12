class SpotVote < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :suggestion_id
end
