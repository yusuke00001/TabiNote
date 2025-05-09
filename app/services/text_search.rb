require "net/http"
require "json"
require "uri"

class TextSearch
  BASE_URL = "https://places.googleapis.com/v1/places:searchText"

  def self.search_spots(keyword:)
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request["X-Goog-FieldMask"] = "places.displayName,places.id"
    request["X-Goog-Api-Key"] = ENV["API_KEY"]
    request.body = { textQuery: keyword, languageCode: "ja" }.to_json # リクエスト本文にkeywordを追加＋json形式変換

    response = http.request(request)
    binding.pry

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)["places"]
    else
      []
    end
  end
end
