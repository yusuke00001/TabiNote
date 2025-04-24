class TripUser < ApplicationRecord
  after_create :trip_users_create
  belongs_to :user
  belongs_to :trip

  enum :host, { member: 0, leader: 1 }
  validates :host, presence: true

  def trip_users_create
    binding.pry
    create(trip_id: trip_id, user_id: user_id, host: :leader)
  end
end
