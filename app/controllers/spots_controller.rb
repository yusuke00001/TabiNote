class SpotsController < ApplicationController
  def index
    return if params[:keyword].blank?
      keyword = Keyword.search_keyword(params[:keyword])
      unless keyword
        spots_data = TextSearch.search_spots(keyword: params[:keyword])

        # キーワードテーブルのレコードを作成
        keyword = Keyword.create_keyword(params[:keyword])

        spots_unique_numbers = spots_data.map { |spot_data| spot_data["id"] }

        new_spots = Spot.unregistrated_unique_number(spots_unique_numbers)

        spot_details = new_spots.map do |new_spot|
          PlaceDetails.search_spot_details(place_id: new_spot)
        end

        # 最終的にspotsに保存したいすべてのパラメータを記述
        spot_details_data = spot_details.map do |spot_detail| {
          unique_number: spot_detail["id"],
          spot_name: spot_detail.dig("displayName", "text"),
          URL: spot_detail["websiteUri"],
          spot_value: spot_detail["rating"],
          address: spot_detail["formattedAddress"],
          image_url: "https://places.googleapis.com/v1/#{spot_detail.dig("photos", 0, "name")}/media?maxWidthPx=800&key=#{ENV["API_KEY"]}"
          }
        end
        Spot.bulk_insert(spot_details_data)
        spots_data = Spot.where(unique_number: spots_unique_numbers)
        spots_data.each do |spot|
          KeywordSpot.create_keyword_spot(keyword_id: keyword.id, spot_id: spot.id)
        end
      end
      # ページネーション
      @keyword = params[:keyword]
      @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
      spots = keyword.spots
      total_spots = spots.count
      @total_page = (total_spots.to_f / 10).ceil
      @search_results = spots.offset((@current_page - 1) * 10).limit(10)
      @next_page = @current_page * 10 < total_spots ? @current_page + 1 : nil
      @previous_page = @current_page > 1 ? @current_page - 1 : nil
      @first_page = @current_page > 1 ? 1 : nil
      @last_page = @current_page * 10 < total_spots ? @total_page : nil
  end
end
