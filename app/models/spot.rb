class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :trips, through: :spot_suggestions, dependent: :destroy
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy

  PER_PAGE = 10
  DEFAULT_PAGE = 1
  MIN_PAGE = 1

  # DB未登録のunique_numberのみ抽出するメソッド
  def self.unregistrated_unique_number(spots_unique_numbers)
    exist_unique_numbers = where(unique_number: spots_unique_numbers).pluck(:unique_number)
    spots_unique_numbers - exist_unique_numbers
  end

  def self.bulk_insert(spot_details_data)
    insert_all(spot_details_data)
  end
end
