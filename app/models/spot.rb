class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy
end
