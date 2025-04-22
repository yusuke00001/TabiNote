class TripsController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trips_params)
    if @trip.save
      @trip.transportation_ids = params[:trip][:trasportation_ids]
      Member.create(
        trip_id: @trip.id,
        user_id: current_user.id,
        host: :leader
      )

      flash[:notice] = "しおりを作成しました"
      redirect_to
    else
      flash.now[:alert] = @trip.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private

  def trips_params
    params.require(:trip).permit(:title, :date, :distination, :spot_suggestion_limit, :spot_vote_limit, :start_time, :finish_time, :image)
  end
end
