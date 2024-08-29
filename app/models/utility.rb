class Utility < ApplicationRecord
  enum utility_type: {service: 0, amentities: 1}
  has_many :utilities_in_room_types, dependent: :destroy
  has_many :room_costs, dependent: :destroy

  has_many :room_types, through: :utilities_in_room_types, source: :room_type

  scope :for_room_type, lambda {|room_type_id|
    joins(:utilities_in_room_types)
      .where(utilities_in_room_types: {room_type_id:})
      .distinct
  }
end
