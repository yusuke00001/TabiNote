require 'rails_helper'

RSpec.describe Genre, type: :model do
  let!(:category1) { Category.create!(name: "sightseeing", stay_time: 90) }
  let!(:category2) { Category.create!(name: "leisure_land", stay_time: 300) }

  let!(:genre1) { Genre.create!(name: "museum", category: category1) }
  let!(:genre2) { Genre.create!(name: "amusement_park", category: category2) }

  let(:spot_types) do
    [
      { name: "museum" },
      { name: "amusement_park" }
    ]
  end
  describe "バリデーションテスト" do
    it "名前がnilだったら無効" do
      genre = Genre.new(
        name: nil,
        category_id: category1.id
      )
      expect(genre).not_to be_valid
      expect(genre.errors[:name]).to include("を入力してください")
    end
    it "名前が重複していたら無効" do
      genre = Genre.new(
        name: "museum",
        category_id: category1.id
      )
      expect(genre).not_to be_valid
      expect(genre.errors[:name]).to include("はすでに存在します")
    end
    it "名前が重複していなければ有効" do
      genre = Genre.new(
        name: "park",
        category_id: category1.id
      )
      expect(genre).to be_valid
    end
  end
  describe "インスタンスメソッド" do
    describe "self.genre_category_hash(spot_types)" do
      it "spot_typesに含まれるgenreがそれぞれどのカテゴリーに対応するのかを出力" do
        expect(Genre.genre_category_hash(spot_types)).to eq({ "amusement_park"=>category2.id, "museum"=>category1.id })
      end
    end
  end
end
