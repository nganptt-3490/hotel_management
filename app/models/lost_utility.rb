class LostUtility < ApplicationRecord
  LOSTUTILITIES_PERMITTED = %i(request_id utility_id quantity).freeze
  belongs_to :request
  belongs_to :utility
  scope :by_request, ->(request_id){where(request_id:)}
end
