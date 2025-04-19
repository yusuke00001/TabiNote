class Transportation < ApplicationRecord
  has_many :trip_transportations
  has_many :trips, through: :trip_transportations, dependent: :destroy
end
