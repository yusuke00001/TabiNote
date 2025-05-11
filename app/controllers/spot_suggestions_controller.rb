class SpotSuggestionsController < ApplicationController
  def create
    spot_suggestion = SpotSuggestion.new(spot_suggestions_params)
    trip = Trip.find(params[:trip_id])
    spot = Spot.find(params[:spot_id])
    if spot_suggestion.save
      flash[:notice] = "スポットの提案に成功しました"
      redirect_to trip_path(trip)
    else
      flash[:alert] = "スポットの提案に失敗しました"
      redirect_to spot_path(spot)
    end
  end

  def destroy
    spot_suggestion = SpotSuggestion.find_by(trip_id: params[:id], spot_id: params[:spot_id])
    trip = Trip.find(params[:id])
    if spot_suggestion.delete
      flash[:notice] = "スポットの削除が完了しました"
      redirect_to trip_path(trip)
    else
      flash[:alert] = "スポットの削除に失敗しました"
      redirect_to trip_path(trip)
    end
  end

  private

  def spot_suggestions_params
    params.permit(:user_id, :trip_id, :spot_id)
  end
end
