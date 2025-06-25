class HomesController < ApplicationController
  def index
    @trips_in_progress = current_user.trips_in_progress
    @trips_past = current_user.trips_past
  end
end
