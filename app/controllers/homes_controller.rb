class HomesController < ApplicationController
  def index
    @trips_in_progress_in_first_row = current_user.trips_in_progress_in_first_row
    @trips_in_progress_in_other_row = current_user.trips_in_progress_in_other_row
    @trips_past = current_user.trips_past
  end
end
