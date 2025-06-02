require "net/http"
require "json"
require "uri"

class DistanceMatrix
  BASE_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"
  def self.spot_distance(origins:, destinations:, mode:)
    origins = origins.map { |origin| "place_id:#{origin}" }
    destinations = destinations.map { |destination| "place_id:#{destination}" }
    params = {
      origins: origins.join("|"),
      destinations: destinations.join("|"),
      mode: mode,
      language: "ja",
      key: ENV["API_KEY"]
    }
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      distance = data["rows"].map do |row|
        row["elements"].map { |n| n["distance"]["value"] }
      end
      duration = data["rows"].map do |row|
        row["elements"].map { |n| n["duration"]["value"]/60 }
      end
      { distance: distance, duration: duration }
    else
      []
    end
  end
end
