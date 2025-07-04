require 'rails_helper'
RSpec.describe Trip, type: :model do
  let(:user) { User.create!(name: "テスト", email: "test@test", password: 123456) }

  let(:trip_data) do
    {
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: Date.today.tomorrow,
      spot_vote_limit: Date.today.tomorrow + 1,
      start_time: Time.parse("08:00"),
      finish_time: Time.parse("20:00"),
      created_user_id: user.id,
      decided_plan_id: nil
    }
  end
  describe "バリデーションテスト" do
    it "タイトルが入力されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(title: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:title]).to include("を入力してください")
    end

    it "目的地が選択されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(destination: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:destination]).to include("を入力してください")
    end
    it "スポット提案期限が入力されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(spot_suggestion_limit: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:spot_suggestion_limit]).to include("を入力してください")
    end
    it "スポット投票期限が入力されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(spot_vote_limit: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:spot_vote_limit]).to include("を入力してください")
    end
    it "観光開始時間が入力されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(start_time: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:start_time]).to include("を入力してください")
    end
    it "観光終了時間が入力されていなかったら作成失敗" do
      trip = Trip.new(trip_data.merge(finish_time: nil))
      expect(trip).not_to be_valid
      expect(trip.errors[:finish_time]).to include("を入力してください")
    end
    it "目的地にDESTINATIONS以外の行き先が入力されている場合は作成失敗" do
      trip = Trip.new(trip_data.merge(destination: "アメリカ"))
      expect(trip).not_to be_valid
    end
  end
  describe "インスタンスメソッド" do
    describe "create_trip_user" do
      it "現在のユーザーをリーダーとしてTripUserに作成" do
        trip = Trip.create!(trip_data)
        trip_user = trip.trip_users.first
        expect(trip_user.trip_id).to eq(trip.id)
        expect(trip_user.user_id).to eq(user.id)
        expect(trip_user.is_leader).to be true
      end
    end
    describe "within_spot_suggestion_limit_date?" do
      it "スポット提案期限が昨日の場合はfalseを返す" do
        trip = Trip.new(trip_data.merge(spot_suggestion_limit: Date.yesterday))
        expect(trip.within_spot_suggestion_limit_date?).to be false
      end
      it "スポット提案期限が今日の場合はtrueを返す" do
        trip = Trip.new(trip_data.merge(spot_suggestion_limit: Date.today))
        expect(trip.within_spot_suggestion_limit_date?).to be true
      end
    end
    describe "within_spot_vote_limit_date?" do
      it "スポット投票期限が昨日の場合はfalseを返す" do
        trip = Trip.new(trip_data.merge(spot_vote_limit: Date.yesterday))
        expect(trip.within_spot_vote_limit_date?).to be false
      end
      it "スポット投票期限が今日の場合はtrueを返す" do
        trip = Trip.new(trip_data.merge(spot_vote_limit: Date.today))
        expect(trip.within_spot_vote_limit_date?).to be true
      end
    end
    describe "until_spot_suggestion_limit_date" do
      it "スポット提案期限までの日数を返す" do
        trip = Trip.new(trip_data)
        expect(trip.until_spot_suggestion_limit_date).to eq 1
      end
    end
    describe "until_spot_vote_limit_date" do
      it "スポット投票期限までの日数を返す" do
        trip = Trip.new(trip_data)
        expect(trip.until_spot_vote_limit_date).to eq 2
      end
    end
    describe "trip_max_time_calculation" do
      it "観光可能時間を返す" do
        trip = Trip.new(trip_data)
        expect(trip.trip_max_time_calculation).to eq 720
      end
    end
      describe "trip_users_sort_by_leader" do
      it "リーダーが先頭に来るように並び順を変更" do
        trip = Trip.create!(trip_data)
        expect(trip.trip_users_sort_by_leader.first.is_leader).to be true
      end
    end
  end
end
