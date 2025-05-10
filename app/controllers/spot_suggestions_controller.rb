class SpotSuggestionsController < ApplicationController
  def create
    spot_suggestion = SpotSuggestion.new(spot_suggestions_params)
    trip = Trip.find(params[:trip_id])
    spot = Spot.find(params[:spot_id])
    if spot_suggestion.save
      flash[:notice] = "スポットの提案に成功しました"
      redirect_to trip_path(trip)
    else
      flash.now[:alert] = "スポットの提案に失敗しました"
      redirect_to spot_path(spot)
    end
  end

  private

  def spot_suggestions_params
    params.permit(:user_id, :trip_id, :spot_id)
  end
end
