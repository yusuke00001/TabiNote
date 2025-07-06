require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category0) {
    Category.create!(
      name: "sightseeing",
      stay_time: 90
    )
  }
  let!(:category1) {
    Category.create!(
      name: "leisure_land",
      stay_time: 300
    )
  }
  let!(:category2) {
    Category.create!(
      name: "nature",
      stay_time: 45
    )
  }
  let(:category_ids) {
    [ category1.id, category2.id, category0.id ]
  }
  describe "バリデーションテスト" do
    it "名前がnilの場合は無効" do
      category = Category.new(name: nil, stay_time: 90)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("を入力してください")
    end
    it "名前が重複している場合は無効" do
      category = Category.new(name: "sightseeing", stay_time: 90)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("はすでに存在します")
    end
    it "名前が重複していない場合は有効" do
      category = Category.new(name: "restaurant", stay_time: 60)
      expect(category).to be_valid
    end
    it "滞在時間がnilの場合は無効" do
      category = Category.new(name: "restaurant", stay_time: nil)
      expect(category).not_to be_valid
      expect(category.errors[:stay_time]).to include("を入力してください")
    end
  end
  describe "クラスメソッド" do
    describe "self.category_stay_time_in_vote_order(category_ids)" do
      it "受け取ったcategory_idsの順番通りにidとstay_timeのハッシュを返す" do
        expect(Category.category_stay_time_in_vote_order(category_ids)).to eq({
          category1.id => category1.stay_time,
          category2.id => category2.stay_time,
          category0.id => category0.stay_time
        })
      end
    end
  end
end
