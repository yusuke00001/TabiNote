require "net/http"
require "json"
require "uri"

class PlaceDetails
  BASE_URL = "https://places.googleapis.com/v1/places/"

  def self.search_spot_details(place_id:)
    uri = URI("#{BASE_URL}#{place_id}")
    uri.query = URI.encode_www_form({ key: ENV["API_KEY"], languageCode: "ja" })

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["X-Goog-Api-Key"] = ENV["API_KEY"]
    request["Content-Type"] = "application/json"
    request["X-Goog-FieldMask"] = "formattedAddress,internationalPhoneNumber,regularOpeningHours,rating,userRatingCount,websiteUri,id,displayName,photos,types"

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      []
    end
  end
end
