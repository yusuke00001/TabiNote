class TripUser < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  def self.change_leader(new_leader_id:, trip_id:, user_id:)
    transaction do
      current_leader = find_by!(trip_id: trip_id, user_id: user_id)
      new_leader = find(new_leader_id)
      current_leader.update!(is_leader?: :false)
      new_leader.update!(is_leader?: :true)
    end
  end

  def sort_leader_first
    trip_users = trip.trip_users.to_a
    leader = trip_users.find { |trip_user| trip_user.is_leader? }
    trip_users.delete(leader)
    trip_users.unshift(leader)
  end

  def current_user?(current_user)
    self.user_id == current_user.id
  end

  def show_leader_change_link?(current_user:, current_user_is_leader:)
    self.user_id != current_user.id && current_user_is_leader
  end

  def show_current_user_delete_link?(current_user:)
    self.user_id == current_user.id && self.is_leader? == false
  end
end
