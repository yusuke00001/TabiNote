class HomesController < ApplicationController
  def index
    @trips_in_progress = Trip.joins(:trip_users).where(trip_users: { user_id: current_user.id }, status: :in_progress)
    @trips_past = Trip.joins(:trip_users).where(trip_users: { user_id: current_user.id }, status: :completed)
  end
end
