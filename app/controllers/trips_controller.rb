class TripsController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trips_params)
    @trip.current_user_id = current_user.id
    if @trip.save
      @trip.transportation_ids = params[:trip][:transportation_ids]

      flash[:notice] = "しおりを作成しました"
      redirect_to trip_path(@trip)
    else
      flash.now[:alert] = @trip.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @spot_suggestions = @trip.spot_suggestions
    @trip_users = @trip.trip_users
  end

  private

  def trips_params
    params.require(:trip).permit(:title, :date, :distination, :spot_suggestion_limit, :spot_vote_limit, :start_time, :finish_time, :image, :creator_id)
  end
end
