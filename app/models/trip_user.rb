class TripUser < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  enum :host, { member: 0, leader: 1 }
  validates :host, presence: true

  def self.change_leader(new_leader_id:, trip_id:, user_id:)
    transaction do
      current_leader = find_by!(trip_id: trip_id, user_id: user_id)
      new_leader = find(new_leader_id)
      current_leader.update!(host: :member)
      new_leader.update!(host: :leader)
    end
  end

  def self.leader_first(trip:)
    trip_users = trip.trip_users.to_a
    leader = trip_users.find { |trip_user| trip_user.host == "leader" }
    trip_users.delete(leader)
    trip_users.unshift(leader)
  end
end
