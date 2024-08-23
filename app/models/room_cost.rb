class RoomCost < ApplicationRecord
  belongs_to :request
  belongs_to :price_fluctuation, optional: true

  scope :by_request_id, ->(request_id){where(request_id:)}
end
