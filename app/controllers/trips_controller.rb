class TripsController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trips_params)
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
    @spot_suggestions = @trip.spots
    @spot_suggestion_by_user = SpotSuggestion.where(trip_id: @trip.id).index_by(&:spot_id)
  end

  def suggestion
    @trip = Trip.find(params[:id])
    @spot_suggestions = @trip.spots
    @spot_suggestion_by_user = SpotSuggestion.where(trip_id: @trip.id).index_by(&:spot_id)
    render partial: "trips/suggestion", locals: { trip: @trip, spot_suggestions: @spot_suggestions, spot_suggestion_by_user: @spot_suggestion_by_user }
  end

  def vote
    @trip = Trip.find(params[:id])
    @spot_votes = @trip.spots
    render partial: "trips/vote", locals: { trip: @trip, spot_votes: @spot_votes }
  end

  private

  def trips_params
    params.require(:trip).permit(:title, :date, :distination, :spot_suggestion_limit, :spot_vote_limit, :start_time, :finish_time, :image, :created_user_id)
  end
end
