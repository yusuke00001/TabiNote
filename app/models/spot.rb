class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :trips, through: :spot_suggestions, dependent: :destroy
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy
  has_many :plan_spots
  has_many :plans, through: :plan_spots
  belongs_to :category

  PER_PAGE = 10
  DEFAULT_PAGE = 1
  MIN_PAGE = 1
  OTHER_CATEGORY_ID = 6

  def self.register_spots(spots_data:, keyword:)
    spots_unique_numbers = spots_data.map { |spot_data| spot_data["id"] }
    new_spots = spots_unique_numbers - where(unique_number: spots_unique_numbers).pluck(:unique_number)
    spot_details = new_spots.map do |new_spot|
      PlaceDetails.search_spot_details(place_id: new_spot)
    end

    # spotのunique_numberとgenreのtype関係性
    spot_types = self.unique_number_to_type(spot_details)

    # Genresのnameとcategory_idのハッシュを取得
    genres = Genre.genre_category_hash(spot_types)

    # unique_numberとcategory_idの配列を作成(Genresテーブルに存在しないnameの場合はcategory_idに6を代入)
    spot_genres = self.unique_number_to_category_id(spot_types: spot_types, genres: genres)

    grouped = spot_genres.group_by { |spot| spot[:unique_number] }

    # spotに対応するcategoryを決定
    spot_category = self.determine_spot_main_category(grouped)

    # 一度配列化することでハッシュ化ができる
    spot_category_hash = spot_category.map { |spot| [ spot[:unique_number], spot[:category_id] ] }.to_h

    spots_insert_all_data = self.spots_insert_all_data(spot_details: spot_details, spot_category_hash: spot_category_hash)

    insert_all!(spots_insert_all_data)

    spot_ids = where(unique_number: spots_unique_numbers).ids

    KeywordSpot.create_keyword_spots(keyword_id: keyword.id, spot_ids: spot_ids)
  end

  def self.unique_number_to_category_id(spot_types:, genres:)
    spot_types.map do |spot_type|
      if genres[spot_type[:name]].nil?
        {
          unique_number: spot_type[:unique_number],
          category_id: OTHER_CATEGORY_ID
        }
      else
        {
          unique_number: spot_type[:unique_number],
          category_id: genres[spot_type[:name]]
        }
      end
    end
  end

  def self.determine_spot_main_category(grouped)
    grouped.map do |unique_number, records|
      sorted = records.group_by { |record| record[:category_id] }.sort_by { |_, category_id| category_id.size }
      first_category_id = sorted[0]&.first
      second_category_id = sorted[1]&.first

      if first_category_id == OTHER_CATEGORY_ID
        most_category_id = second_category_id
      else
        most_category_id = first_category_id
      end
      { unique_number: unique_number, category_id: most_category_id }
    end
  end

  def self.unique_number_to_type(spot_details)
    spot_details.flat_map do |spot_detail|
      spot_detail["types"].map do |type| {
        unique_number: spot_detail["id"],
        name: type
      }
      end
    end
  end

  def self.spots_insert_all_data(spot_details:, spot_category_hash:)
    spot_details.map do |spot_detail|
      category_id = spot_category_hash[spot_detail["id"]] || OTHER_CATEGORY_ID
      {
      unique_number: spot_detail["id"],
      spot_name: spot_detail.dig("displayName", "text"),
      URL: spot_detail["websiteUri"],
      spot_value: spot_detail["rating"],
      address: spot_detail["formattedAddress"],
      image_url: "https://places.googleapis.com/v1/#{spot_detail.dig("photos", 0, "name")}/media?maxWidthPx=800&key=#{ENV["API_KEY"]}",
      category_id: category_id
      }
    end
  end

  def self.spots_data_sort(spots_unique_numbers)
    spots_data = where(unique_number: spots_unique_numbers).index_by(&:unique_number)
    spots_unique_numbers.map { |s| spots_data[s] }
  end

  def self.spots_all_combination_for_best_route(spots_combination:, category_ids:, category_stay_time_sort:, total_hours:, spot_distance:, travel_max_time:)
    best_route = nil
    must_include_spots = nil
    essential_spot = nil
    (0..spots_combination.size - 1).each do |removed|
      total_hours, best_route, must_include_spots = self.combinations_with_removal(spots_combination: spots_combination, removed: removed, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, spot_distance: spot_distance, total_hours: total_hours, best_route: best_route, must_include_spots: must_include_spots, essential_spot: essential_spot)
      if total_hours < travel_max_time && must_include_spots.present?
        return [ [ best_route ], must_include_spots ]
      end
    end
  end

  def self.spots_all_combination_for_other_routes(spots_combination:, category_ids:, category_stay_time_sort:, spot_distance:, travel_max_time:, must_include_spots:)
    other_routes = []
    must_include_spots.each do |essential_spot|
      best_route = nil
      total_hours = Float::INFINITY
      (0..spots_combination.size - 1).each do |removed|
        total_hours, best_route = self.combinations_with_removal(spots_combination: spots_combination, removed: removed, essential_spot: essential_spot, category_ids: category_ids, category_stay_time_sort: category_stay_time_sort, spot_distance: spot_distance, total_hours: total_hours, best_route: best_route, must_include_spots: must_include_spots)
        if total_hours < travel_max_time
          other_routes << best_route
          break
        end
      end
    end
    other_routes
  end


  def self.combinations_with_removal(spots_combination:, removed:, category_ids:, category_stay_time_sort:, total_hours:, best_route:, spot_distance:, must_include_spots:, essential_spot:)
    spots_combination.combination(removed).each do |removed_spot|
      if removed_spot.include?(essential_spot)
        next
      end
      spots_combination_new = spots_combination - removed_spot
      category_ids_new = category_ids.each_with_index.reject { |_, index| removed_spot.include?(index) }.map(&:first)
      total_stay_time = category_ids_new.map { |id| category_stay_time_sort[id] }.sum
      total_hours, best_route, must_include_spots = self.spots_combination_permutation(spots_combination: spots_combination_new, total_hours: total_hours, best_route: best_route, total_stay_time: total_stay_time, spot_distance: spot_distance, removed_spot: removed_spot, must_include_spots: must_include_spots)
    end
    [ total_hours, best_route, must_include_spots ]
  end

  def self.spots_combination_permutation(spots_combination:, total_hours:, best_route:, total_stay_time:, spot_distance:, removed_spot:, must_include_spots:)
    spots_combination.permutation.each do |n|
      total_move_time = 0
      n.each_cons(2) { |a, b| total_move_time += spot_distance[:duration][a][b] }
      if total_move_time + total_stay_time < total_hours
        total_hours = total_move_time + total_stay_time
        best_route = n
        must_include_spots = removed_spot
      end
    end
    [ total_hours, best_route, must_include_spots ]
  end


  def move_duration(plan)
    self.plan_spots.find_by(plan_id: plan.id).duration
  end
end


def self.spots_combination_permutation_second_route(spots_combination:, total_hours:, best_route:, total_stay_time:, spot_distance:)
  spots_combination.permutation.each do |n|
    total_move_time = 0
    n.each_cons(2) { |a, b| total_move_time += spot_distance[:duration][a][b] }
    if total_move_time + total_stay_time < total_hours
      total_hours = total_move_time + total_stay_time
      best_route = n
    end
  end
  [ total_hours, best_route ]
end



def self.combinations_with_removal(spots_combination:, removed:, category_ids:, category_stay_time_sort:, total_hours:, best_route:, spot_distance:, must_include_spots:)
  spots_combination.combination(removed).each do |removed_spot|
    spots_combination_new = spots_combination - removed_spot
    category_ids_new = category_ids.each_with_index.reject { |_, index| removed_spot.include?(index) }.map(&:first)
    total_stay_time = category_ids_new.map { |id| category_stay_time_sort[id] }.sum
    total_hours, best_route, must_include_spots = self.spots_combination_permutation(spots_combination: spots_combination_new, total_hours: total_hours, best_route: best_route, total_stay_time: total_stay_time, spot_distance: spot_distance, removed_spot: removed_spot, must_include_spots: must_include_spots)
  end
  [ total_hours, best_route, must_include_spots ]
end

def self.combinations_with_removal_for_second_route(spots_combination:, removed:, essential_spot:, category_ids:, category_stay_time_sort:, spot_distance:, total_hours:, best_route:, must_include_spots:)
  spots_combination.combination(removed).each do |removed_spot|
    if removed_spot.include?(essential_spot)
      next
    end
    spots_combination_new = spots_combination - removed_spot
    category_ids_new = category_ids.each_with_index.reject { |_, index| removed_spot.include?(index) }.map(&:first)
    total_stay_time = category_ids_new.map { |id| category_stay_time_sort[id] }.sum
    total_hours, best_route, must_include_spots = self.spots_combination_permutation(spots_combination: spots_combination_new, total_hours: total_hours, best_route: best_route, total_stay_time: total_stay_time, spot_distance: spot_distance, total_hours: total_hours, must_include_spots: must_include_spots, removed_spot: removed_spot)
  end
  [ total_hours, best_route ]
end
