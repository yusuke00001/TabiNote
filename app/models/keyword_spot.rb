class KeywordSpot < ApplicationRecord
  belongs_to :keyword
  belongs_to :spot

  def self.create_keyword_spots(keyword_id:, spot_ids:)
    spot_ids.each do |spot_id|
      create!(keyword_id: keyword_id, spot_id: spot_id)
    end
  end
end
