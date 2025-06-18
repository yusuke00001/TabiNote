class Category < ApplicationRecord
  has_many :genres
  has_many :spots

  validates :name, uniqueness: true

  def self.category_stay_time_sort(category_ids)
    category_data = Category.where(id: category_ids).index_by(&:id)
    category_ids.map { |s| category_data[s] }.pluck(:id, :stay_time).to_h
  end
end
