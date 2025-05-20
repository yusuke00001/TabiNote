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
    @spot_suggestions = @trip.spot_suggestions
    spot_votes = @trip.spot_votes.pluck(:spot_suggestion_id)
    ng_spot = spot_votes.group_by { |s| s }.select { |_, value| value.size >= 2 }.keys
    @voted_result = @spot_suggestions.reject { |spot| ng_spot.include?(spot.id) }
  end

  def suggestion
    @trip = Trip.find(params[:id])
    @spot_suggestions = @trip.spot_suggestions
    render partial: "trips/suggestion", locals: { trip: @trip, spot_suggestions: @spot_suggestions }
  end

  def vote
    @trip = Trip.find(params[:id])
    @spot_suggestions = @trip.spot_suggestions
    voted_spot_suggestion_ids = SpotVote.where(trip_id: @trip, user_id: current_user.id).pluck(:spot_suggestion_id)
    @voted_spot_suggestions = @spot_suggestions.select { |s| voted_spot_suggestion_ids.include?(s.id) }
    @not_voted_spot_suggestions = @spot_suggestions.reject { |s| voted_spot_suggestion_ids.include?(s.id) }
    render partial: "trips/vote", locals: { trip: @trip, spot_suggestions: @spot_suggestions, voted_spot_suggestions: @voted_spot_suggestions, not_voted_spot_suggestions: @not_voted_spot_suggestions }
  end

  private

  def trips_params
    params.require(:trip).permit(:title, :date, :distination, :spot_suggestion_limit, :spot_vote_limit, :start_time, :finish_time, :image, :created_user_id)
  end
end
