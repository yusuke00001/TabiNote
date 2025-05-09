class Spot < ApplicationRecord
  has_many :spot_suggestions
  has_many :keyword_spots
  has_many :keywords, through: :keyword_spots, dependent: :destroy

  # DB未登録のunique_numberのみ抽出するメソッド
  def self.unregistrated_unique_number(spots_unique_numbers)
    exist_unique_numbers = where(unique_number: spots_unique_numbers).pluck(:unique_number)
    spots_unique_numbers - exist_unique_numbers
  end

  def self.bulk_insert(spot_details_data)
    insert_all(spot_details_data)
  end
end
