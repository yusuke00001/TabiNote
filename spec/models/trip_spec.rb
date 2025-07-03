require 'rails_helper'

RSpec.describe Trip, type: :model do
  it "タイトルが入力されていなかったら作成失敗" do
    trip = Trip.new(
      title: nil,
      destination: "北海道",
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: "2025-07-11",
      start_time: "08:00",
      finish_time: "20:00",
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:title]).to include("を入力してください")
  end

  it "目的地が選択されていなかったら作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: nil,
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: "2025-07-11",
      start_time: "08:00",
      finish_time: "20:00",
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:destination]).to include("を入力してください")
  end
  it "スポット提案期限が入力されていなかったら作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: nil,
      spot_vote_limit: "2025-07-11",
      start_time: "08:00",
      finish_time: "20:00",
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:spot_suggestion_limit]).to include("を入力してください")
  end
  it "スポット投票期限が入力されていなかったら作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: nil,
      start_time: "08:00",
      finish_time: "20:00",
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:spot_vote_limit]).to include("を入力してください")
  end
  it "観光開始時間が入力されていなかったら作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: "2025-07-11",
      start_time: nil,
      finish_time: "20:00",
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:start_time]).to include("を入力してください")
  end
  it "観光終了時間が入力されていなかったら作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: "北海道",
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: "2025-07-11",
      start_time: "08:00",
      finish_time: nil,
    )
    expect(trip).not_to be_valid
    expect(trip.errors[:finish_time]).to include("を入力してください")
  end
  it "目的地にDESTINATIONS以外の行き先が入力されている場合は作成失敗" do
    trip = Trip.new(
      title: "卒業旅行",
      destination: "アメリカ",
      spot_suggestion_limit: "2025-07-10",
      spot_vote_limit: "2025-07-11",
      start_time: "08:00",
      finish_time: "22:00",
    )
    expect(trip).not_to be_valid
  end
end
