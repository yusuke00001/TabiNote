class User < ApplicationRecord
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

  def get_user_avatar
    unless avatar.attached?
      file_path = Rails.root.join("app/assets/images/default_image.jpg")
      avatar.attach(io: File.open(file_path), filename: "default_image.jpg", content_type: "image/jpeg")
    end
    avatar
  end
end
