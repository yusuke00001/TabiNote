class PlansController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])
    @plans = @trip.plans
    @trip_users = @trip.trip_users
    if @trip.decided_plan_id.present?
      redirect_to trip_path(@trip)
    end

    @elements = {}
    Plan.plans_display_data_create(elements: @elements, plans: @plans, trip: @trip)
  end
  def create
    trip = Trip.find(params[:trip_id])
    unless TripUser.current_user_is_leader?(trip: trip, current_user: current_user)
      redirect_to trip_plans_path
      return
    end
    spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")

    number_of_spots = spot_distance[:duration].size

    total_hours = Float::INFINITY

    trip_max_time = (trip.finish_time - trip.start_time)/Plan::SIXTY_MINUTES

    spots_unique_numbers = params[:spot_unique_numbers]
    spots_in_vote_order = Spot.spots_in_vote_order(spots_unique_numbers)

    category_ids = spots_in_vote_order.map(&:category_id)
    category_stay_time_in_vote_order = Category.category_stay_time_in_vote_order(category_ids)

    spots_combination = Spot.all_spot_index(number_of_spots)
    # 各スポットの組み合わせパターンを検討し、制限時間内に収まる最短ルートを取得
    routes, must_include_spots = Spot.spots_all_combination_for_best_route(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_in_vote_order: category_stay_time_in_vote_order, total_hours: total_hours, spot_distance: spot_distance, trip_max_time: trip_max_time)

    if must_include_spots.present?
      routes += Spot.spots_all_combination_for_other_routes(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_in_vote_order: category_stay_time_in_vote_order, spot_distance: spot_distance, trip_max_time: trip_max_time, must_include_spots: must_include_spots)
    end
    begin
      ActiveRecord::Base.transaction do
        routes.each_with_index do |route, index|
          plan = Plan.create!(trip_id: trip.id, title: index + 1)
          PlanSpot.plan_spots_create(route: route, spots_in_vote_order: spots_in_vote_order, spot_distance: spot_distance, plan: plan)
        end
        flash[:notice] = "プランを作成しました"
        redirect_to trip_plans_path(trip_id: trip.id)
      end
    rescue => e
      Rails.logger.error "プラン作成でエラー発生: #{e.class} - #{e.message}"
      flash[:alert]  = "プランを生成することができませんでした"
      redirect_back fallback_location: homes_path
    end
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @plan = Plan.find(params[:id])
    @elements = {}
    @plan.plan_element_create(@elements)
  end

  def update
    @plan = Plan.find(params[:id])
    @trip = @plan.trip
    @elements = {}
    @plan.plan_element_create(@elements)
    trip_max_time = (@trip.finish_time - @trip.start_time)/Plan::SIXTY_MINUTES
    begin
      ActiveRecord::Base.transaction do
        plan_params[:update_dates].each do |update_date|
          spot_id = update_date["spot_id"].to_i
          stay_time = update_date["stay_time"].to_i
          plan_spot = PlanSpot.find_by!(spot_id: spot_id, plan_id: @plan.id)
          plan_spot.update!(stay_time: stay_time)
        end
        total_times = 0
        @plan.plan_spots.each do |plan_spot|
          total_times += (plan_spot.stay_time + plan_spot.duration)
        end
        if trip_max_time >= total_times
          flash[:notice] = "更新に成功しました"
          redirect_to edit_trip_plan_path(@trip, @plan)
        else
          raise "滞在時間と移動時間の合計が観光可能時間を超えています"
        end
      end
    rescue RuntimeError
      flash.now[:alert] = "滞在時間と移動時間の合計が観光可能時間を超えています"
      render :edit, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "編集処理でエラー発生: #{e.class} - #{e.message}"
      flash.now[:alert] = "プランを更新することができませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def plan_params
    params.permit(update_dates: [ :spot_id, :stay_time ])
  end
end
