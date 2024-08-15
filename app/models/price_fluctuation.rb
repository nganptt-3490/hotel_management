class PriceFluctuation < ApplicationRecord
  has_many :room_costs, dependent: :destroy
end
