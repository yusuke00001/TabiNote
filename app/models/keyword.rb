class Keyword < ApplicationRecord
  has_many :keyword_spots
  has_many :spots, through: :keyword_spots, dependent: :destroy
end
