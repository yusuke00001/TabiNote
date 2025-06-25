class TripUsersController < ApplicationController
  before_action :store_location, only: [ :join_page ]
  skip_before_action :authenticate_user!, only: [ :join_page ]

  def index
    @trip = Trip.find(params[:trip_id])
    @trip_users = @trip.trip_users.order(is_leader: :desc)
  end

  def join_page
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path(from: "join_page") and return
    end
    @trip = Trip.find(params[:trip_id])
  end
  def create
    if TripUser.exists?(user_id: current_user.id, trip_id: params[:trip_id])
      flash[:alert] = "すでにこのしおりに参加しています！"
      redirect_to trip_path(params[:trip_id])
    else
      TripUser.create!(user_id: current_user.id, trip_id: params[:trip_id])
      flash[:notice] = "しおりに参加しました！"
      redirect_to trip_path(params[:trip_id])
    end
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

  def store_location
    store_location_for(:user, request.fullpath)
  end
end
