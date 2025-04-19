class Trip < ApplicationRecord
  has_many :trip_transportations
  has_many :transportations, through: :trip_transportations, dependent: :destroy
  belongs_to :user

  enum :status, { in_progress: 1, completed: 2 }
end
