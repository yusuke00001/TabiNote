require "net/http"
require "json"
require "uri"

class GoogleplacesApi
  BASE_URL = "https://places.googleapis.com/v1/places:searchText"

  def self.search_spots(keyword:)
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::POST.new(uri.path)
    request["X-Goog-Api-Key"] = ENV["API_KEY"]
    request.body = { textQuery: keyword }.to_json # リクエスト本文にkeywordを追加＋json形式変換

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      []
    end
  end
end
