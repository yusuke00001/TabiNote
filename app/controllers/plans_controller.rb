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
    spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")

    number_of_spots = spot_distance[:duration].size

    total_hours = Float::INFINITY

    travel_max_time = (trip.finish_time - trip.start_time)/Plan::SIXTY_MINUTES

    spots_unique_numbers = params[:spot_unique_numbers]
    spots_in_vote_order = Spot.spots_in_vote_order(spots_unique_numbers)

    category_ids = spots_in_vote_order.map(&:category_id)
    category_stay_time_sort = Category.category_stay_time_sort(category_ids)

    spots_combination = Spot.all_spot_index(number_of_spots)
    # 各スポットの組み合わせパターンを検討し、制限時間内に収まる最短ルートを取得
    routes, must_include_spots = Spot.spots_all_combination_for_best_route(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, total_hours: total_hours, spot_distance: spot_distance, travel_max_time: travel_max_time)

    if must_include_spots.present?
      routes += Spot.spots_all_combination_for_other_routes(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, spot_distance: spot_distance, travel_max_time: travel_max_time, must_include_spots: must_include_spots)
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
end
