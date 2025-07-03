require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前が存在していればユーザーを作成" do
    user = User.new(
      name: "内藤",
      email: "test@test",
      password: "test123"
      )
    expect(user).to be_valid
  end

  it "名前が存在しない場合はユーザー登録失敗" do
    user = User.new(
      name: nil,
      email: "test@test",
      password: "test123"
    )
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("を入力してください")
  end
end
