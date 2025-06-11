class Trip < ApplicationRecord
  after_create :create_trip_user

  has_many :trip_transportations
  has_many :transportations, through: :trip_transportations, dependent: :destroy
  has_many :trip_users
  has_many :users, through: :trip_users, dependent: :destroy
  has_many :spot_suggestions
  has_many :spots, through: :spot_suggestions, dependent: :destroy
  has_many :spot_votes
  has_one_attached :image

  enum :status, { in_progress: 0, completed: 1 }
  validates :title, presence: true
  validates :distination, presence: true
  validates :spot_suggestion_limit, presence: true
  validates :spot_vote_limit, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  def create_trip_user
    TripUser.create!(trip_id: id, user_id: created_user_id, is_leader: true)
  end

  def within_spot_suggestion_limit_date?
    self.spot_suggestion_limit >= Date.today
  end

  def within_spot_vote_limit_date?
    self.spot_vote_limit >= Date.today
  end

  def until_spot_suggestion_limit_date
    (self.spot_suggestion_limit - Date.today).to_i
  end

  def until_spot_vote_limit_date
    (self.spot_vote_limit - Date.today).to_i
  end

  def sort_leader_first
    trip_users = self.trip_users.to_a
    leader = trip_users.find { |trip_user| trip_user.is_leader? }
    trip_users.delete(leader)
    trip_users.unshift(leader)
  end
end
