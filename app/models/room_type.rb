class RoomType < ApplicationRecord
  has_many :utilities_in_room_types, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :utilities, through: :utilities_in_room_types, source: :utility

  scope :ordered_by_name, ->{order(name: :asc)}
  scope :by_ids, ->(ids){where(id: ids)}
end
