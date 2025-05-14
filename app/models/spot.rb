class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :trips, through: :spot_suggestions, dependent: :destroy
  has_many :users, through: :spot_suggestions
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy

  PER_PAGE = 10
  DEFAULT_PAGE = 1
  MIN_PAGE = 1

  def self.register_spots(spots_data:, keyword:)
    spots_unique_numbers = spots_data.map { |spot_data| spot_data["id"] }
    new_spots = spots_unique_numbers - where(unique_number: spots_unique_numbers).pluck(:unique_number)
    spot_details = new_spots.map do |new_spot|
      PlaceDetails.search_spot_details(place_id: new_spot)
    end

    insert_all(
      spot_details_data = spot_details.map do |spot_detail| {
        unique_number: spot_detail["id"],
        spot_name: spot_detail.dig("displayName", "text"),
        URL: spot_detail["websiteUri"],
        spot_value: spot_detail["rating"],
        address: spot_detail["formattedAddress"],
        image_url: "https://places.googleapis.com/v1/#{spot_detail.dig("photos", 0, "name")}/media?maxWidthPx=800&key=#{ENV["API_KEY"]}"
        }
      end
    )
    spot_ids = where(unique_number: spots_unique_numbers).ids
    spot_ids.each do |spot_id|
      KeywordSpot.create(keyword_id: keyword.id, spot_id: spot_id)
    end
  end
end
