class TripUsersController < ApplicationController
  def index
    @trip = Trip.find(params[:trip])
    @trip_users = @trip.trip_users
  end

  def update
    member = TripUser.find_by!(trip_id: params[:trip_id], user_id: params[:user_id])
    current_leader = TripUser.find_by!(trip_id: params[:trip], user_id: current_user.id)
    current_leader.update!(host: :member)
    member.update!(host: :leader)
  end

  def destroy
    trip_user = TripUser.find_by!(trip_id: params[:trip_id], user_id: params[:user_id])
    trip = trip_user.trip
    if trip_user.destroy
      flash[:notice] = "#{trip.name}から退会しました"
      redirect_to homes_path
    else
      flash[:alert] = "退会できませんでした"
      redirect_back fallback_location: homes_path
    end
  end
end
