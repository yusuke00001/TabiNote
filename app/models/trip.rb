class Trip < ApplicationRecord
  has_many :trip_transportations
  has_many :transportations, through: :trip_transportations, dependent: :destroy
  has_one_attached :image
  belongs_to :user

  enum :status, { in_progress: 1, completed: 2 }
  validates :title, presence: true
  validates :distination, presence: true
  validates :spot_suggestion_limit, presence: true
  validates :spot_vote_limit, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates :image, presence: true
end
