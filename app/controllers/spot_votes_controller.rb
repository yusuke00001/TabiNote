class SpotVotesController < ApplicationController
  def create
    suggestion_ids = params[:spot_suggestion_ids]
    suggestion_ids.each do |suggestion_id|
      SpotVote.create!(trip_id: params[:trip_id], spot_suggestion_id: suggestion_id, user_id: current_user.id)
    end
    flash[:notice] = "投票しました"
    redirect_to trip_path(params[:trip_id])
  end
end
