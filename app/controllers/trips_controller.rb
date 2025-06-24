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

  def decided_plan
    trip = Trip.find(params[:id])
    if params[:selected_plan_id].blank?
      flash[:alert] = "プランが選択されていません"
      redirect_back fallback_location: homes_path and return
    end

    begin
      trip.update!(decided_plan_id: params[:selected_plan_id])
      flash[:notice] = "プランを作成しました"
      redirect_to trip_path(trip)
    rescue
      flash[:alert] = "プランの選択ができませんでした。 別のプランをお試しください"
      redirect_back fallback_location: homes_path
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @trip_users = @trip.trip_users.order(is_leader: :desc)
    spot_votes = @trip.spot_votes.pluck(:spot_suggestion_id)
    ng_spot = SpotVote.ng_spot_decided(spot_votes: spot_votes, trip_users: @trip_users)
    @voted_result = SpotSuggestion.voted_result(trip: @trip, ng_spot: ng_spot)
    @decided_plan = Plan.find_by(id: @trip.decided_plan_id)
    if @decided_plan.present?
      @elements = Plan.plans_display_data_create(plans: @decided_plan, trip: @trip)
    end
  end

  def suggestion
    trip = Trip.find(params[:id])
    render partial: "trips/suggestion", locals: { trip: trip, spot_suggestions: trip.spot_suggestions }
  end

  def vote
    trip = Trip.find(params[:id])
    voted_spot_suggestions = SpotVote.voted_spot_suggestions(trip)
    current_user_voted_spot_suggestions = SpotVote.where(trip_id: trip.id, user_id: current_user.id).pluck(:spot_suggestion_id)
    render partial: "trips/vote", locals: { trip: trip, spot_suggestions: trip.spot_suggestions, voted_spot_suggestions: voted_spot_suggestions, current_user_voted_spot_suggestions: current_user_voted_spot_suggestions }
  end

  private

  def trips_params
    params.require(:trip).permit(:title, :date, :destination, :spot_suggestion_limit, :spot_vote_limit, :start_time, :finish_time, :image, :created_user_id)
  end
end
