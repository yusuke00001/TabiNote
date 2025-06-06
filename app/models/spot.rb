class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :trips, through: :spot_suggestions, dependent: :destroy
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy

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

    spot_types = spot_details.flat_map do |spot_detail|
      spot_detail["types"].map do |type| {
        unique_number: spot_detail["id"],
        name: type
      }
      end
    end

    # nameに対応するcategoryのidを取得
    genre_names = spot_types.map { |spot_type| spot_type[:name] }.uniq
    genres = Genre.where(name: genre_names).pluck(:name, :category_id).to_h

    # unique_numberとcategory_idの配列を作成(Genresテーブルに存在しないnameの場合はcategory_idに6を代入)
    spot_genres = spot_types.map do |spot_type|
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

    grouped = spot_genres.group_by { |spot| spot[:unique_number] }

    spot_category = grouped.map do |unique_number, records|
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
    # 一度配列化することでハッシュ化ができる
    spot_category_hash = spot_category.map { |spot| [ spot[:unique_number], spot[:category_id] ] }.to_h

    spots_insert_all_data = spot_details.map do |spot_detail|
      # 開発環境ではcategory_idがnilになることがあったため
      category_id = spot_category_hash[spot_detail["id"]] || OTHER_CATEGORY_ID
      if category_id.nil?
        Rails.logger.warn("category_idが見つかりません: #{spot_detail["id"]}")
        category_id = OTHER_CATEGORY_ID
      end
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
    insert_all!(spots_insert_all_data)

    spot_ids = where(unique_number: spots_unique_numbers).ids
    spot_ids.each do |spot_id|
      KeywordSpot.create!(keyword_id: keyword.id, spot_id: spot_id)
    end
  end
end
