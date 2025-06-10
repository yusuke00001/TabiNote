class Category < ApplicationRecord
  has_many :genres
  has_many :spots

  validates :name, uniqueness: true

  def self.category_stay_time_sort(spots_data_sort:, category_ids:)
    category_data = Category.where(id: category_ids).index_by(&:id)
    category_ids.map { |s| category_data[s] }.map(&:stay_time)
  end
end
