class SpotsController < ApplicationController
  def index
    word = params[:keyword]
    return if word.blank?

    begin
      ActiveRecord::Base.transaction do
        trip = Trip.find(params[:trip_id])
        Keyword.find_or_create_keyword_and_fetch_spots(word: word, trip: trip)
      end
    rescue => e
      Rails.logger.error "スポット検索でエラー発生: #{e.class} - #{e.message}"
      flash[:alert]  = "正しく検索を行うことができませんでした。再度検索を行ってください"
      redirect_back fallback_location: homes_path and return
    end

    # ページネーション
    keyword = Keyword.find_by(word: word)
    @keyword = params[:keyword]
    @current_page = Spot.safe_page(params)
    spots = keyword.spots
    total_spots = spots.count
    @total_page = Spot.total_page_numbers(total_spots)
    @search_results = Spot.search_result_by_current_page(spots: spots, current_page: @current_page)
    @next_page = Spot.next_page_if_not_last(current_page: @current_page, total_spots: total_spots)
    @previous_page = Spot.previous_page_if_not_first(@current_page)
    @first_page = Spot.first_page_if_not_first(@current_page)
    @last_page = Spot.last_page_if_not_last(current_page: @current_page, total_spots: total_spots, total_page: @total_page)
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @spot = Spot.find(params[:id])
  end
end
