require 'rails_helper'

RSpec.describe Genre, type: :model do
  let!(:category1) { Category.create!(name: "sightseeing") }
  let!(:category2) { Category.create!(name: "leisure_land") }

  let!(:genre1) { Genre.create!(name: "museum", category: category1) }
  let!(:genre2) { Genre.create!(name: "amusement_park", category: category2) }

  let(:spot_types) do
    [
      { name: "museum" },
      { name: "amusement_park" }
    ]
  end
  describe "バリデーションテスト" do
    it "レコードを作成する際に名前が存在しなかったら作成失敗" do
      genre = Genre.new(
        name: nil,
        category_id: category1.id
      )
      expect(genre).not_to be_valid
      expect(genre.errors[:name]).to include("を入力してください")
    end
    it "レコードを作成する際にすでに名前が存在していたら作成失敗" do
      genre = Genre.new(
        name: "museum",
        category_id: category1.id
      )
      expect(genre).not_to be_valid
      expect(genre.errors[:name]).to include("はすでに存在します")
    end
    it "レコードを作成する際に重複しない名前が存在していたら作成成功" do
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
