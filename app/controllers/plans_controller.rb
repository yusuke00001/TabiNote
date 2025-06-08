class PlansController < ApplicationController
  def create
    trip = Trip.find(params[:trip_id])
    # spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")
    spot_distance = {
      distance: [
        [ 0, 79948, 31923, 68078 ],
        [ 76392, 0, 42631, 12595 ],
        [ 31982, 45826, 0, 35528 ],
        [ 66607, 13597, 32846, 0 ]
      ],
      duration: [
        [ 0, 79, 54, 68 ],
        [ 77, 0, 55, 22 ],
        [ 53, 55, 0, 44 ],
        [ 67, 25, 45, 0 ]
      ]
    }
    number_of_spots = spot_distance[:duration].size

    # 移動時間と滞在時間の合計
    total_hours = Float::INFINITY

    # 移動時間が最小になる組み合わせを取得
    best_route = nil

    # 観光に使える時間
    travel_max_time = (trip.finish_time - trip.start_time)/60

    # スポットデータの取得
    # spotsレコードを格納(順番はバラバラ)
    spots_unique_numbers = params[:spot_unique_numbers]
    # ビューから渡されたスポット順に変更
    spots_data = Spot.where(unique_number: spots_unique_numbers).index_by(&:unique_number)
    spots_data_sort = spots_unique_numbers.map { |s| spots_data[s] }
    category_ids = spots_data_sort.map(&:category_id)
    category_data = Category.where(id: category_ids).index_by(&:id)
    category_stay_time_sort = category_ids.map { |s| category_data[s] }.map(&:stay_time)
    spots_combination = (0..number_of_spots-1).to_a
    (0..spots_combination.size - 1).each do |removed|
      spots_combination.combination(removed).each do |removed_spot|
        spots_combination_new = spots_combination - removed_spot
        category_ids_new = category_ids.each_with_index.reject { |_, index| removed_spot.include?(index) }.map(&:first)
        # DBからレコードを呼び出す際に、同じレコードは排除されてしまうため以下のように記述
        total_stay_time = category_ids_new.map { |id| category_stay_time_sort[id] }.sum
        spots_combination_new.permutation.each do |n|
          # ここでtotal_move_timeを毎回初期化
          total_move_time = 0
          n.each_cons(2) { |a, b| total_move_time += spot_distance[:duration][a][b] }
          if total_move_time + total_stay_time < total_hours
            total_hours = total_move_time + total_stay_time
            best_route = n
          end
        end
      end
      if total_hours < travel_max_time
        ActiveRecord::Base.transaction do
          # best_routeの順番に変更
          orderd_spots = best_route.map { |i| spots_data_sort[i] }
          # best_routeの順番通りにスポットを回る際の各スポットの移動距離
          durations = best_route.each_cons(2).map { |a, b| spot_distance[:duration][a][b] }
          binding.pry
          plan = Plan.create!(trip_id: trip.id)
          orderd_spots.each_with_index do |spot, index|
            puts "#{index}: #{spot.nil? ? 'nil' : spot.id}"
          end
          plan_spots_insert_all_data = orderd_spots.each_with_index.map do |spot, index|
            {
              plan_id: plan.id,
              order: index + 1,
              spot_id: spot.id,
              duration: durations[index] || 0
            }
          end
          PlanSpot.insert_all!(plan_spots_insert_all_data)
          puts best_route
          flash[:notice] = "プランを作成しました"
          # redirect_to
          return
        end
      end
    end
  end
end
