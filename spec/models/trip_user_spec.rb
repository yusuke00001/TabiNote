require 'rails_helper'

RSpec.describe TripUser, type: :model do
  before do
    @users = [
        User.create!(name: "test", email: "test@test", password: "test123"),
        User.create!(name: "test2", email: "test2@test2", password: "test123")
      ]
    @trip = Trip.create!(
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: Date.today.tomorrow,
      spot_vote_limit: Date.today.tomorrow + 1,
      start_time: Time.parse("08:00"),
      finish_time: Time.parse("20:00"),
      created_user_id: @users[0].id,
      decided_plan_id: nil
    )
    @trip_user_0 = TripUser.find_by!(
      trip_id: @trip.id,
      user_id: @users[0].id
    )
    @trip_user_1 = TripUser.create!(
      trip_id: @trip.id,
      user_id: @users[1].id
    )
  end
  describe "self.change_leader(new_leader_id:, trip_id:, user_id:)" do
    it "指定したユーザーをリーダーに変更する" do
      TripUser.change_leader(new_leader_id: @trip_user_1.id, trip_id: @trip.id, user_id: @users[0].id)
      expect(TripUser.find_by!(user_id: @users[0].id).is_leader?).to be false
      expect(TripUser.find_by!(user_id: @users[1].id).is_leader?).to be true
    end
  end
  describe "self.current_user_is_leader?(trip:, current_user:)" do
    it "自分自身がリーダーならtrueを返す" do
      expect(TripUser.current_user_is_leader?(trip: @trip, current_user: @users[0])).to be true
    end
    it "自分自身がリーダーではない場合はfalseを返す" do
      expect(TripUser.current_user_is_leader?(trip: @trip, current_user: @users[1])).to be false
    end
  end
  describe "current_user?" do
    it "自分自身を対象とする場合はtrueを返す" do
      expect(@trip_user_0.current_user?(@users[0])).to be true
    end
    it "自分以外を対象とする場合はfalseを返す" do
      expect(@trip_user_1.current_user?(@users[0])).to be false
    end
  end
  describe "show_leader_change_link?(current_user:, trip:)" do
    it "リーダーが他のユーザーを対象とする場合はtrueを返す" do
      expect(@trip_user_1.show_leader_change_link?(current_user: @users[0], trip: @trip)).to be true
    end
    it "リーダーが自分自身を対象とする場合はfalseを返す" do
      expect(@trip_user_0.show_leader_change_link?(current_user: @users[0], trip: @trip)). to be false
    end
    it "自分自身がリーダーではない場合はfalseを返す" do
      expect(@trip_user_0.show_leader_change_link?(current_user: @users[1], trip: @trip)).to be false
      expect(@trip_user_1.show_leader_change_link?(current_user: @users[1], trip: @trip)).to be false
    end
  end
  describe "show_current_user_delete_link?(current_user:)" do
    it "リーダーではないユーザーが自分自身を対象とする場合はtrueを返す" do
      expect(@trip_user_1.show_current_user_delete_link?(current_user: @users[1])).to be true
    end
    it "リーダーが自分自身を対象とする場合はfalseを返す" do
      expect(@trip_user_0.show_current_user_delete_link?(current_user: @users[0])).to be false
    end
    it "他ユーザーを対象とする場合は全てfalseを返す" do
      expect(@trip_user_0.show_current_user_delete_link?(current_user: @users[1])).to be false
    end
  end
end
