class HomesController < ApplicationController
  def index
    @trips_in_progress_first_row = current_user.trips_in_progress_first_row
    @trips_in_progress_other_row = current_user.trips_in_progress_other_row
    @trips_past = current_user.trips_past
  end
end
