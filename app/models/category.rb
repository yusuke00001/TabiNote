class Category < ApplicationRecord
  has_many :genres
  has_many :spots

  validates :name, uniqueness: true
end
