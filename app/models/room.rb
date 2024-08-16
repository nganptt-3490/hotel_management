class Room < ApplicationRecord
  enum status: {active: 0, inactive: 1}
  belongs_to :room_type
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy

  scope :excluding_ids, ->(ids){where.not(id: ids)}
  scope :by_ids, ->(ids){where(id: ids)}
end
