class SpotVote < ApplicationRecord
  belongs_to :user
  belogns_to :trip
  belogns_to :suggestion_id
end
