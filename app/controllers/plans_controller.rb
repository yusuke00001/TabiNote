class PlansController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])
    @plans = @trip.plans
  end
  def create
    trip = Trip.find(params[:trip_id])
    # spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")

    spot_distance = { distance:
      [ [ 0, 9163, 25420, 23551, 45356, 83406 ],
      [ 8977, 0, 13174, 11305, 46306, 84356 ],
      [ 24670, 16487, 0, 626, 53220, 91270 ],
      [ 29158, 16465, 1139, 0, 53197, 91247 ],
      [ 45180, 46025, 55571, 53703, 0, 42671 ],
      [ 84157, 85002, 94548, 92680, 42872, 0 ] ],
      duration:
        [ [ 0, 16, 30, 29, 38, 83 ],
        [ 15, 0, 22, 22, 42, 88 ],
        [ 31, 25, 0, 1, 49, 95 ],
        [ 32, 24, 4, 0, 49, 94 ],
        [ 37, 41, 50, 50, 0, 53 ],
        [ 83, 87, 96, 95, 52, 0 ] ]
    }

    number_of_spots = spot_distance[:duration].size

    total_hours = Float::INFINITY

    travel_max_time = (trip.finish_time - trip.start_time)/60

    spots_unique_numbers = params[:spot_unique_numbers]
    spots_data_sort = Spot.spots_data_sort(spots_unique_numbers)

    category_ids = spots_data_sort.map(&:category_id)
    category_stay_time_sort = Category.category_stay_time_sort(spots_data_sort: spots_data_sort, category_ids: category_ids)

    spots_combination = (0..number_of_spots-1).to_a
    # 各スポットの組み合わせパターンを検討し、制限時間内に収まる最短ルートを取得
    best_route, necessary_for_second_plans = Spot.spots_all_combination(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, total_hours: total_hours, spot_distance: spot_distance, travel_max_time: travel_max_time)

    other_routes = []
    if necessary_for_second_plans.present?
      other_routes = Spot.spots_all_combination_for_second_route(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, spot_distance: spot_distance, travel_max_time: travel_max_time, necessary_for_second_plans: necessary_for_second_plans)
    end

    other_routes.unshift(best_route)

    ActiveRecord::Base.transaction do
      other_routes.each_with_index do |other_route, index|
        orderd_spots = other_route.map { |i| spots_data_sort[i] }
        durations = other_route.each_cons(2).map { |a, b| spot_distance[:duration][a][b] }
        plan = Plan.create!(trip_id: trip.id, title: index + 1)
        plan_spots_insert_all_data = PlanSpot.create_plan_spots_insert_all_data(orderd_spots: orderd_spots, durations: durations, plan: plan)
        PlanSpot.insert_all!(plan_spots_insert_all_data)
      end
      flash[:notice] = "プランを作成しました"
      redirect_to trip_plans_path(trip_id: trip.id)
    end
  end
end
