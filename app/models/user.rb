class User < ApplicationRecord
  before_save :user_avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trip_users
  has_many :trips, through: :trip_users, dependent: :destroy
  has_many :spot_suggestions
  has_many :spot_vote
  has_one_attached :avatar

  validates :name, presence: :true

  def user_avatar
    unless avatar.attached?
      file_path = Rails.root.join("app/assets/images/default_image.jpg")
      avatar.attach(io: File.open(file_path), filename: "default_image.jpg", content_type: "image/jpeg")
    end
    avatar
  end

  def trips_in_progress
    trips.in_progress
  end

  def trips_past
    trips.completed
  end
end
