class SpotVotesController < ApplicationController
  def create
    suggestion_ids = params[:spot_suggestion_ids]
    spot_suggestion_duplication = false
    Array(suggestion_ids).each do |suggestion_id|
      begin
        SpotVote.create!(trip_id: params[:trip_id], spot_suggestion_id: suggestion_id, user_id: current_user.id)
      rescue ActiveRecord::RecordNotUnique
        spot_suggestion_duplication = true
      end
    end
    if spot_suggestion_duplication
      flash[:alert] = "すでに投票されています"
    else
      flash[:notice] = "投票しました"
    end
    redirect_to trip_path(params[:trip_id])
  end
end
