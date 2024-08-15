class Request < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :room_type
  has_many :lost_utilities, dependent: :destroy
  has_many :room_costs, dependent: :destroy
end
