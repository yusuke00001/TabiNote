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
Category.create(name: "nature", stay_time: 50)
Category.create(name: "restaurant", stay_time: 60)
Category.create(name: "other")

Transportation.create(name: "車")
Transportation.create(name: "電車")
Transportation.create(name: "自転車")

CSV.foreach("db/seed_files/genres.csv") do |row|
  Genre.create(name: row[0], category_id: row[1])
end
