class Trip < ApplicationRecord
  after_create :create_trip_user

  has_many :trip_transportations
  has_many :transportations, through: :trip_transportations, dependent: :destroy
  has_many :trip_users
  has_many :users, through: :trip_users, dependent: :destroy
  has_many :spot_suggestions
  has_many :spot_vote
  has_one_attached :image

  enum :status, { in_progress: 0, completed: 1 }
  validates :title, presence: true
  validates :distination, presence: true
  validates :spot_suggestion_limit, presence: true
  validates :spot_vote_limit, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  def create_trip_user
    TripUser.create(trip_id: id, user_id: created_user_id, host: :leader)
  end
end
