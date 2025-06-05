class SpotsController < ApplicationController
  def index
    word = params[:keyword]
    return if word.blank?

    begin
      ActiveRecord::Base.transaction do
        Keyword.find_or_create_keyword_and_fetch_spots(word: word)
      end
    rescue => e
      Rails.logger.error "スポット検索でエラー発生: #{e.class} - #{e.message}"
      flash[:alert]  = "正しく検索を行うことができませんでした。再度検索を行ってください"
      redirect_back fallback_location: homes_path and return
    end

    # ページネーション
    keyword = Keyword.find_by(word: word)
    @keyword = params[:keyword]
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : Spot::DEFAULT_PAGE
    spots = keyword.spots
    total_spots = spots.count
    @total_page = (total_spots.to_f / Spot::PER_PAGE).ceil
    @search_results = spots.offset((@current_page - 1) * Spot::PER_PAGE).limit(Spot::PER_PAGE)
    @next_page = @current_page * Spot::PER_PAGE < total_spots ? @current_page + 1 : nil
    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @first_page = @current_page > 1 ? Spot::MIN_PAGE : nil
    @last_page = @current_page * Spot::PER_PAGE < total_spots ? @total_page : nil
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @spot = Spot.find(params[:id])
  end
end
