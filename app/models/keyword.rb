class Keyword < ApplicationRecord
  has_many :keyword_spots
  has_many :spots, through: :keyword_spots, dependent: :destroy

  def self.search_keyword(keyword)
    find_by(word: keyword)
  end

  def self.create_keyword(keyword)
    create(word: keyword)
  end
end
