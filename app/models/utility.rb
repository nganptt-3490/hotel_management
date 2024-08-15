class Utility < ApplicationRecord
  enum utility_type: {service: 0, amentities: 1}
  has_many :utilities_in_room_types, dependent: :destroy
  has_many :room_costs, dependent: :destroy

  has_many :room_types, through: :utilities_in_room_types, source: :room_type
end
