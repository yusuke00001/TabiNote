class SpotSuggestionsController < ApplicationController
  def create
    spot_suggestion = SpotSuggestion.new(spot_suggestions_params)
    if spot_suggestion.save
      flash[:notice] = "スポットの提案に成功しました"
      redirect_to trip_path(spot_suggestion.trip_id)
    else
      flash[:alert] = "スポットの提案に失敗しました"
      redirect_back fallback_location: trip_spots_path(spot_suggestion.trip_id)
    end
  end

  def destroy
    spot_suggestion = SpotSuggestion.find_by!(trip_id: params[:id], spot_id: params[:spot_id])
    if spot_suggestion.delete
      flash[:notice] = "スポットの削除が完了しました"
      redirect_to trip_path(spot_suggestion.trip_id)
    else
      flash[:alert] = "スポットの削除に失敗しました"
      redirect_back fallback_location: trip_path(spot_suggestion.trip_id)
    end
  end

  private

  def spot_suggestions_params
    params.require(:spot_suggestion).permit(:user_id, :spot_id).merge(trip_id: params[:trip_id])
  end
end
