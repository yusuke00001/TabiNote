class HomesController < ApplicationController
  def index
    @trips_in_progress = Trip.where(user_id: current_user.id, status: :in_progress)
    @trips_past = Trip.where(user_id: current_user.id, status: :complited)
  end
end
