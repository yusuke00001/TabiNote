class TripUsersController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])
    @trip_users = @trip.trip_users
    @current_user_trip_user = @trip_users.find_by(user_id: current_user.id)
  end

  def change_leader
    new_leader = TripUser.find(params[:id])
    TripUser.change_leader(new_leader_id: new_leader.id, trip_id: params[:trip_id], user_id: current_user.id)
    flash[:notice] = "#{new_leader.user.name}さんが幹事になりました"
    redirect_back fallback_location: homes_path
  end

  def destroy
    trip_user = TripUser.find(params[:id])
    trip = trip_user.trip
    if trip_user.destroy
      flash[:notice] = "#{trip.title}から退会しました"
      redirect_to homes_path
    else
      flash[:alert] = "退会できませんでした"
      redirect_back fallback_location: homes_path
    end
  end
end
