class Trip < ApplicationRecord
  DESTINATIONS = [
    "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
    "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
    "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県",
    "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県",
    "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
  ]
  after_create :create_trip_user

  has_many :trip_transportations
  has_many :transportations, through: :trip_transportations, dependent: :destroy
  has_many :trip_users
  has_many :users, through: :trip_users, dependent: :destroy
  has_many :spot_suggestions
  has_many :spots, through: :spot_suggestions, dependent: :destroy
  has_many :spot_votes
  has_many :plans
  has_one_attached :image

  enum :status, { in_progress: 0, completed: 1 }
  validates :title, presence: true
  validates :distination, presence: true
  validates :spot_suggestion_limit, presence: true
  validates :spot_vote_limit, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates :destination, inclusion: { in: DESTINATIONS }

  def create_trip_user
    TripUser.create!(trip_id: id, user_id: created_user_id, is_leader: true)
  end

  def within_spot_suggestion_limit_date?
    self.spot_suggestion_limit >= Date.today
  end

  def within_spot_vote_limit_date?
    self.spot_vote_limit >= Date.today
  end

  def until_spot_suggestion_limit_date
    (self.spot_suggestion_limit - Date.today).to_i
  end

  def until_spot_vote_limit_date
    (self.spot_vote_limit - Date.today).to_i
  end

  def trip_users_sort_by_leader
    self.trip_users.order(is_leader: :desc)
  end

  def get_trip_image
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/default_trip_image.webp")
      image.attach(io: File.open(file_path), filename: "default_trip_image.webp", content_type: "image/webp")
    end
    image
  end
end
