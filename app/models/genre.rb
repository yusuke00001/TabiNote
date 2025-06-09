class Genre < ApplicationRecord
  has_many :genre_spots
  has_many :spots, through: :genre_spots
  belongs_to :category

  validates :name, uniqueness: true

  def self.genre_category_hash(spot_types)
    genre_names = spot_types.map { |spot_type| spot_type[:name] }.uniq
    where(name: genre_names).pluck(:name, :category_id).to_h
  end
end
