class PlansController < ApplicationController
  def create
    spot_distance = DistanceMatrix.spot_distance(origins: params[:spot_unique_numbers], destinations: params[:spot_unique_numbers], mode: "driving")
    number_of_spots = spot_distance[:duration].size
    minimum = Float::INFINITY
    best_route = nil
    (0..number_of_spots-1).to_a.permutation.each do |n|
      total_time = 0
      n.each_cons(2) { |a, b| total_time += spot_distance[:duration][a][b] }
      if total_time < minimum
        minimum = total_time
        best_route = n
      end
    end
    binding.pry
    trip = Trip.find(params[:trip_id])
    # plan = Plan.create!
    # PlanTrip.create_plan_trips(plan_id: plan.id, trip_id: params[:trip_id])
    # PlanSpot.create_plan_spots(plan_id: plan.id, spot_ids: params[:spot_ids])
    # flash[:notice] = "プランを作成しました"
    redirect_to trip_path(trip)
  end
end
