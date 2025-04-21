class HomesController < ApplicationController
  def index
    @trips_in_progress = Trip.joins(:members).where(members: { user_id: current_user.id }, status: :in_progress)
    @trips_past = Trip.joins(:members).where(members: { user_id: current_user.id }, status: :completed)
  end
end
