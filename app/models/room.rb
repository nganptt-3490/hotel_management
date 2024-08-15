class Room < ApplicationRecord
  enum type: {active: 0, inactive: 1}
  belongs_to :room_type
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy
end
