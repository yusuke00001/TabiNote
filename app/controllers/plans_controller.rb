class PlansController < ApplicationController
  def create
    trip = Trip.find(params[:trip_id])
    spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")

    number_of_spots = spot_distance[:duration].size

    total_hours = Float::INFINITY

    best_route = nil

    travel_max_time = (trip.finish_time - trip.start_time)/60

    spots_unique_numbers = params[:spot_unique_numbers]
    spots_data_sort = Spot.spots_data_sort(spots_unique_numbers)

    category_ids = spots_data_sort.map(&:category_id)
    category_stay_time_sort = Category.category_stay_time_sort(spots_data_sort: spots_data_sort, category_ids: category_ids)

    spots_combination = (0..number_of_spots-1).to_a
    # 各スポットの組み合わせパターンを検討し、制限時間内に収まる最短ルートを取得
    best_route = Spot.spots_all_combination(spots_combination: spots_combination, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, total_hours: total_hours, best_route: best_route, spot_distance: spot_distance, travel_max_time: travel_max_time)

    ActiveRecord::Base.transaction do
      orderd_spots = best_route.map { |i| spots_data_sort[i] }
      durations = best_route.each_cons(2).map { |a, b| spot_distance[:duration][a][b] }
      plan = Plan.create!(trip_id: trip.id)
      plan_spots_insert_all_data = PlanSpot.create_plan_spots_insert_all_data(orderd_spots: orderd_spots, durations: durations, plan: plan)
      PlanSpot.insert_all!(plan_spots_insert_all_data)
      flash[:notice] = "プランを作成しました"
      # redirect_to
      return
    end
  end
end
