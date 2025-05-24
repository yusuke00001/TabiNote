require "net/http"
require "json"
require "uri"

class DistanceMatrix
  BASE_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"
  def self.spot_distance(origin:, destination:, mode:)
    params = {
      origins: origin,
      destinations: destination,
      mode: mode,
      language: "ja",
      key: ENV["API_KEY"]
    }
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      []
    end
  end
end
