# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_05_234717) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stay_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_genres_on_category_id"
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "keyword_spots", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_keyword_spots_on_keyword_id"
    t.index ["spot_id"], name: "index_keyword_spots_on_spot_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "word", null: false
    t.string "location_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_spots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.integer "duration"
    t.integer "stay_time"
    t.bigint "spot_id", null: false
    t.bigint "plan_id", null: false
    t.index ["plan_id"], name: "index_plan_spots_on_plan_id"
    t.index ["spot_id"], name: "index_plan_spots_on_spot_id"
  end

  create_table "plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "trip_id", null: false
    t.index ["trip_id"], name: "index_plans_on_trip_id"
  end

  create_table "spot_suggestions", force: :cascade do |t|
    t.datetime "deadline"
    t.bigint "trip_id", null: false
    t.bigint "spot_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_spot_suggestions_on_spot_id"
    t.index ["trip_id", "spot_id"], name: "index_spot_suggestions_on_trip_id_and_spot_id", unique: true
    t.index ["trip_id"], name: "index_spot_suggestions_on_trip_id"
    t.index ["user_id"], name: "index_spot_suggestions_on_user_id"
  end

  create_table "spot_votes", force: :cascade do |t|
    t.datetime "deadline"
    t.bigint "spot_suggestion_id", null: false
    t.bigint "trip_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_suggestion_id"], name: "index_spot_votes_on_spot_suggestion_id"
    t.index ["trip_id", "spot_suggestion_id", "user_id"], name: "index_spot_votes_on_trip_id_and_spot_suggestion_id_and_user_id", unique: true
    t.index ["trip_id"], name: "index_spot_votes_on_trip_id"
    t.index ["user_id"], name: "index_spot_votes_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.string "spot_name"
    t.string "unique_number"
    t.string "phone_number"
    t.string "opening_hours"
    t.string "spot_value"
    t.text "URL"
    t.string "address"
    t.text "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "fk_rails_bb6f27e9e4"
    t.index ["unique_number"], name: "index_spots_on_unique_number", unique: true
  end

  create_table "transportations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_transportations_on_name", unique: true
  end

  create_table "trip_transportations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "transportation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transportation_id"], name: "index_trip_transportations_on_transportation_id"
    t.index ["trip_id"], name: "index_trip_transportations_on_trip_id"
  end

  create_table "trip_users", force: :cascade do |t|
    t.boolean "is_leader", default: false, null: false
    t.bigint "user_id", null: false
    t.bigint "trip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_trip_users_on_trip_id"
    t.index ["user_id", "trip_id"], name: "index_trip_users_on_user_id_and_trip_id", unique: true
    t.index ["user_id"], name: "index_trip_users_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.date "date"
    t.string "destination", null: false
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.integer "status", default: 0, null: false
    t.date "spot_suggestion_limit", null: false
    t.date "spot_vote_limit", null: false
    t.bigint "created_user_id", null: false
    t.bigint "decided_plan_id"
    t.index ["created_user_id"], name: "fk_rails_2542cd4bd9"
    t.index ["decided_plan_id"], name: "fk_rails_c84f0818ee"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "genres", "categories", on_update: :cascade
  add_foreign_key "keyword_spots", "keywords", on_update: :cascade, on_delete: :cascade
  add_foreign_key "keyword_spots", "spots", on_update: :cascade, on_delete: :cascade
  add_foreign_key "plan_spots", "plans", on_update: :cascade, on_delete: :cascade
  add_foreign_key "plan_spots", "spots", on_update: :cascade, on_delete: :cascade
  add_foreign_key "plans", "trips", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_suggestions", "spots", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_suggestions", "trips", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_suggestions", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_votes", "spot_suggestions", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_votes", "trips", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spot_votes", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "spots", "categories"
  add_foreign_key "trip_transportations", "transportations", on_update: :cascade, on_delete: :cascade
  add_foreign_key "trip_transportations", "trips", on_update: :cascade, on_delete: :cascade
  add_foreign_key "trip_users", "trips", on_update: :cascade, on_delete: :cascade
  add_foreign_key "trip_users", "users", on_update: :cascade
  add_foreign_key "trips", "plans", column: "decided_plan_id", on_update: :cascade
  add_foreign_key "trips", "users", column: "created_user_id", on_update: :cascade, on_delete: :cascade
end
