# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "csv"

Category.create(name: "sightseeing", stay_time: 90)
Category.create(name: "shopping", stay_time: 60)
Category.create(name: "leisure_land", stay_time: 300)
Category.create(name: "nature", stay_time: 45)
Category.create(name: "restaurant", stay_time: 60)
Category.create(name: "other", stay_time: 60)
lunch_category = Category.create(name: "lunch_break", stay_time: 90)

Transportation.create(name: "車")
Transportation.create(name: "電車")
Transportation.create(name: "自転車")

User.create(name: "player1", email: "player@1", password: 123456, password_confirmation: 123456)
User.create(name: "player2", email: "player@2", password: 123456, password_confirmation: 123456)
User.create(name: "player3", email: "player@3", password: 123456, password_confirmation: 123456)

CSV.foreach("db/seed_files/genres.csv") do |row|
  Genre.create(name: row[0], category_id: row[1])
end

Spot.create(spot_name: "お昼休憩", category_id: lunch_category.id)
