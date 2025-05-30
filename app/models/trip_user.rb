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

  def current_user?(current_user)
    self.user_id == current_user.id
  end
  def show_leader_change_link?(current_user:, current_user_host:)
    self.user_id != current_user.id && current_user_host == "leader"
  end

  def show_current_user_delete_link?(current_user:)
    self.user_id == current_user.id && self.host == "member"
  end
end
