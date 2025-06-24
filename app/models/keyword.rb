class Keyword < ApplicationRecord
  has_many :keyword_spots
  has_many :spots, through: :keyword_spots, dependent: :destroy

  def self.find_or_create_keyword_and_fetch_spots(word:, trip:)
    keyword = find_by(word: word, location_name: trip.destination)
    unless keyword.present?
      location = Trip::PREFECTURE_CENTERS[trip.destination]
      lat = location[0]
      lng = location[1]
      spots_data = TextSearch.search_spots(keyword: word, lat: lat, lng: lng)
      keyword = create!(word: word, location_name: trip.destination)
      Spot.register_spots(spots_data: spots_data, keyword: keyword)
    end
  end
end
