class Genre < ApplicationRecord
  has_many :genre_spots
  has_many :spots, through: :genre_spots
  belongs_to :category

  def self.insert_all(spot_types_summary)
    insert_all!(
    spot_types_summary
    )
  end

  # APIから取得したtypeの順番に沿った対応するspot_id
  def self.find_genre_id(spot_types_summary)
    where(type: spot_types_summary)
    .order("Field(type, #{spot_types_summary})").ids
  end
end
