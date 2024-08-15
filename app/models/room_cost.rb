class RoomCost < ApplicationRecord
  belongs_to :request
  belongs_to :price_fluctuation
end
