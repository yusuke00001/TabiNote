class SpotVotesController < ApplicationController
  def create
    binding.pry
    suggestion_ids = params[:spot_suggestion_ids]
    begin
      SpotVote.register(trip_id: params[:trip_id], suggestion_ids: suggestion_ids, user_id: current_user.id)
      flash[:notice] = "投票しました"
    rescue ActiveRecord::RecordNotUnique
      flash[:alert] = "すでに投票されています"
    end
    redirect_to trip_path(params[:trip_id])
  end
end
