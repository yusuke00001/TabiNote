class KeywordSpot < ApplicationRecord
  belongs_to :keyword
  belongs_to :spot

  def self.create_keyword_spot(keyword_id:, spot_id:)
    create!(keyword_id: keyword_id, spot_id: spot_id)
  end
end
