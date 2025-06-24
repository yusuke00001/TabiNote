class Spot < ApplicationRecord
  require "open-uri"

  has_many :spot_suggestions
  has_many :trips, through: :spot_suggestions, dependent: :destroy
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy
  has_many :plan_spots
  has_many :plans, through: :plan_spots
  has_one_attached :image
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

    Spot.save_image(spots_unique_numbers)

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
      phone_number: spot_detail.dig("internationalPhoneNumber")&.sub(/\A\+81\s?/, "0"),
      opening_hours: spot_detail.dig("regularOpeningHours", "weekdayDescriptions")&.join("\n\n"),
      URL: spot_detail["websiteUri"],
      spot_value: spot_detail["rating"],
      address: spot_detail["formattedAddress"]&.sub(/\A日本、/, ""),
      image_url: "https://places.googleapis.com/v1/#{spot_detail.dig("photos", 0, "name")}/media?maxWidthPx=800&key=#{ENV["API_KEY"]}",
      category_id: category_id
      }
    end
  end

  def self.spots_in_vote_order(spots_unique_numbers)
    spots_data = where(unique_number: spots_unique_numbers).index_by(&:unique_number)
    spots_unique_numbers.map { |s| spots_data[s] }
  end

  def self.spots_all_combination_for_best_route(spots_combination:, category_ids:, category_stay_time_in_vote_order:, total_hours:, spot_distance:, trip_max_time:)
    best_route = nil
    must_include_spots = nil
    essential_spot = nil
    self.removal_index_range(spots_combination).each do |removed|
      total_hours, best_route, must_include_spots = self.combinations_with_removal(spots_combination: spots_combination, removed: removed, category_ids: category_ids, category_stay_time_in_vote_order: category_stay_time_in_vote_order, spot_distance: spot_distance, total_hours: total_hours, best_route: best_route, must_include_spots: must_include_spots, essential_spot: essential_spot)
      if total_hours < trip_max_time
        return [ [ best_route ], must_include_spots ]
      end
    end
  end

  def self.spots_all_combination_for_other_routes(spots_combination:, category_ids:, category_stay_time_in_vote_order:, spot_distance:, trip_max_time:, must_include_spots:)
    other_routes = []
    must_include_spots.each do |essential_spot|
      best_route = nil
      total_hours = Float::INFINITY
      total_hours, other_routes = self.exclude_spots_combination(spots_combination: spots_combination, trip_max_time: trip_max_time, other_routes: other_routes, total_hours: total_hours, best_route: best_route, essential_spot: essential_spot, must_include_spots:, category_ids:, spot_distance: spot_distance, category_stay_time_in_vote_order: category_stay_time_in_vote_order)
    end
    other_routes
  end

  def self.exclude_spots_combination(spots_combination:, trip_max_time:, other_routes:, total_hours:, best_route:, essential_spot:, category_ids:, category_stay_time_in_vote_order:, spot_distance:, must_include_spots:)
    self.removal_index_range(spots_combination).each do |removed|
      total_hours, best_route = self.combinations_with_removal(spots_combination: spots_combination, removed: removed, essential_spot: essential_spot, category_ids: category_ids, category_stay_time_in_vote_order: category_stay_time_in_vote_order, spot_distance: spot_distance, total_hours: total_hours, best_route: best_route, must_include_spots: must_include_spots)
      if total_hours < trip_max_time
        other_routes << best_route
        break
      end
    end
    [ total_hours, other_routes ]
  end

  def self.combinations_with_removal(spots_combination:, removed:, category_ids:, category_stay_time_in_vote_order:, total_hours:, best_route:, spot_distance:, must_include_spots:, essential_spot:)
    spots_combination.combination(removed).each do |removed_spot|
      if removed_spot.include?(essential_spot)
        next
      end
      spots_combination_new = spots_combination - removed_spot
      category_ids_new = self.exclude_removed_category_ids(category_ids: category_ids, removed_spot: removed_spot)
      total_stay_time = self.calculate_total_stay_time(category_ids_new: category_ids_new, category_stay_time_in_vote_order: category_stay_time_in_vote_order)
      total_hours, best_route, must_include_spots = self.spots_combination_permutation(spots_combination: spots_combination_new, total_hours: total_hours, best_route: best_route, total_stay_time: total_stay_time, spot_distance: spot_distance, removed_spot: removed_spot, must_include_spots: must_include_spots)
    end
    [ total_hours, best_route, must_include_spots ]
  end

  def self.exclude_removed_category_ids(category_ids:, removed_spot:)
    category_ids.each_with_index.reject { |_, index| removed_spot.include?(index) }.map(&:first)
  end

  def self.calculate_total_stay_time(category_ids_new:, category_stay_time_in_vote_order:)
    category_ids_new.map { |id| category_stay_time_in_vote_order[id] }.sum
  end

  def self.spots_combination_permutation(spots_combination:, total_hours:, best_route:, total_stay_time:, spot_distance:, removed_spot:, must_include_spots:)
    spots_combination.permutation.each do |combination|
      total_move_time = 0
      total_move_time = self.move_time_between_spots(combination: combination, spot_distance: spot_distance).sum
      if total_move_time + total_stay_time < total_hours
        total_hours, best_route, must_include_spots = self.update_best_route(total_move_time: total_move_time, total_stay_time: total_stay_time, total_hours: total_hours, combination: combination, removed_spot: removed_spot)
      end
    end
    [ total_hours, best_route, must_include_spots ]
  end

  def self.move_time_between_spots(combination:, spot_distance:)
    combination.each_cons(2).map { |a, b| self.time_ceil_fifteen(spot_distance[:duration][a][b]) }
  end

  def self.update_best_route(total_move_time:, total_stay_time:, total_hours:, combination:, removed_spot:)
    total_hours = total_move_time + total_stay_time
    best_route = combination
    must_include_spots = removed_spot
    [ total_hours, best_route, must_include_spots ]
  end

  def move_duration(plan)
    self.plan_spots.find_by(plan_id: plan.id).duration
  end

  def self.removal_index_range(spots_combination)
    (0...spots_combination.size)
  end

  def self.all_spot_index(number_of_spots)
    (0...number_of_spots).to_a
  end

  def self.safe_page(params)
    (params[:page].to_i > 0) ? params[:page].to_i : Spot::DEFAULT_PAGE
  end

  def self.total_page_numbers(total_spots)
    (total_spots.to_f / Spot::PER_PAGE).ceil
  end

  def self.search_result_by_current_page(spots:, current_page:)
    spots.offset((current_page - 1) * Spot::PER_PAGE).limit(Spot::PER_PAGE)
  end

  def self.next_page_if_not_last(current_page:, total_spots:)
    current_page * Spot::PER_PAGE < total_spots ? current_page + 1 : nil
  end

  def self.previous_page_if_not_first(current_page)
    current_page > 1 ? current_page - 1 : nil
  end

  def self.first_page_if_not_first(current_page)
    current_page > 1 ? Spot::MIN_PAGE : nil
  end

  def self.last_page_if_not_last(current_page:, total_spots:, total_page:)
    current_page * Spot::PER_PAGE < total_spots ? total_page : nil
  end

  def self.time_ceil_fifteen(duration)
    (duration.to_f / 15).ceil * 15
  end

  def self.save_image(spots_unique_numbers)
    spots = where(unique_number: spots_unique_numbers)
    spots.each do |spot|
      if spot.image_url.blank?
        spot.attach_default_image
      else
        begin
          file = URI.open(spot.image_url)
          spot.image.attach(io: file, filename: "#{spot.spot_name.parameterize}.jpg")
        rescue => e
          Rails.logger.warn("画像取得失敗: #{e.message}")
          spot.attach_default_image
        end
      end
    end
  end

  def attach_default_image
    default_image_path = Rails.root.join("app/assets/images/default_no_image.png")
    self.image.attach(
      io: File.open(default_image_path),
      filename: "default_no_image.png",
      content_type: "image/png"
    )
  end
end
