class HomesController < ApplicationController
  def index
    @trips = Trip.where(user_id: current_user.id)
  end
end
