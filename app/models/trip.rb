class Trip < ApplicationRecord
  before_create :trip_image, unless: -> { Rails.env.test? }
  after_create :create_trip_user
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
  PREFECTURE_CENTERS = {
  "北海道" => [ 43.46722, 142.8278 ],
  "青森県" => [ 40.78028, 140.8319 ],
  "岩手県" => [ 39.59139, 141.3625 ],
  "宮城県" => [ 38.44556, 140.9281 ],
  "秋田県" => [ 39.7475, 140.4086 ],
  "山形県" => [ 38.44639, 140.1028 ],
  "福島県" => [ 37.37889, 140.2253 ],
  "茨城県" => [ 36.30639, 140.3186 ],
  "栃木県" => [ 36.68917, 139.8192 ],
  "群馬県" => [ 36.50389, 138.9853 ],
  "埼玉県" => [ 35.99667, 139.3478 ],
  "千葉県" => [ 35.51278, 140.2039 ],
  "東京都" => [ 35.01833, 139.5986 ],
  "神奈川県" => [ 35.41417, 139.3403 ],
  "新潟県" => [ 37.51889, 138.9172 ],
  "富山県" => [ 36.63611, 137.2681 ],
  "石川県" => [ 36.76583, 136.7714 ],
  "福井県" => [ 35.84667, 136.2272 ],
  "山梨県" => [ 35.61222, 138.6117 ],
  "長野県" => [ 36.13000, 138.0439 ],
  "岐阜県" => [ 35.7775, 137.055 ],
  "静岡県" => [ 34.97698, 138.38305 ],
  "愛知県" => [ 35.18019, 136.90657 ],
  "三重県" => [ 34.73028, 136.50859 ],
  "滋賀県" => [ 35.00453, 135.86859 ],
  "京都府" => [ 35.02100, 135.75561 ],
  "大阪府" => [ 34.68632, 135.51971 ],
  "兵庫県" => [ 34.69128, 135.18303 ],
  "奈良県" => [ 34.68533, 135.83274 ],
  "和歌山県" => [ 34.22603, 135.16751 ],
  "鳥取県" => [ 35.50387, 134.23767 ],
  "島根県" => [ 35.47230, 133.05050 ],
  "岡山県" => [ 34.66177, 133.93468 ],
  "広島県" => [ 34.39656, 132.45962 ],
  "山口県" => [ 34.18612, 131.47050 ],
  "徳島県" => [ 34.06577, 134.55930 ],
  "香川県" => [ 34.34015, 134.04344 ],
  "愛媛県" => [ 33.84166, 132.76536 ],
  "高知県" => [ 33.55971, 133.53108 ],
  "福岡県" => [ 33.60679, 130.41831 ],
  "佐賀県" => [ 33.24937, 130.29882 ],
  "長崎県" => [ 32.74484, 129.87376 ],
  "熊本県" => [ 32.78983, 130.74167 ],
  "大分県" => [ 33.23819, 131.61259 ],
  "宮崎県" => [ 31.91109, 131.42386 ],
  "鹿児島県" => [ 31.56015, 130.55798 ],
  "沖縄県" => [ 26.21240, 127.68093 ]
}

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
  validates :destination, presence: true
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

  def trip_image
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/default_trip_image.webp")
      image.attach(io: File.open(file_path), filename: "default_trip_image.webp", content_type: "image/webp")
    end
    image
  end

  def trip_max_time_calculation
    (self.finish_time - self.start_time)/Plan::SIXTY_MINUTES
  end
end
