class Keyword < ApplicationRecord
  has_many :keyword_spots
  has_many :spots, through: :keyword_spots, dependent: :destroy

  def self.find_or_create_and_spot(word:)
    transaction do
      keyword = find_by(word: word)
      unless keyword.present?
        spots_data = TextSearch.search_spots(keyword: word)
        keyword = create!(word: word)
        Spot.register_spots(spots_data: spots_data, keyword: keyword)
      end
    end
  end
end
