class TextSearch
  BASE_URL = "https://places.googleapis.com/v1/places:searchText"

  def self.search_spots(keyword:, lat:, lng:)
    all_results = []
    page_token = nil

    3.times do
      uri = URI(BASE_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["X-Goog-FieldMask"] = "places.displayName,places.id"
      request["X-Goog-Api-Key"] = ENV["API_KEY"]

      body = {
        textQuery: keyword, locationBias: { circle: { center: { latitude: lat, longitude: lng }, radius: 5000 } }, languageCode: "ja"
      }
      body[:pageToken] = page_token if page_token
      request.body = body.to_json

      response = http.request(request)
      json = JSON.parse(response.body)

      if response.is_a?(Net::HTTPSuccess)
        all_results.concat(json["places"]) if json["places"]
        page_token = json["nextPageToken"]
        break unless page_token
        sleep(3)
      else
        break
      end
    end
    all_results
  end
end
