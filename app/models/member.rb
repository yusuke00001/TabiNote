class Member < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  enum :host, { member: 0, leader: 1 }
  validates :host, presence: true
end
