class Review < ApplicationRecord
  REVIEWS_PERMITTED = %i(user_id request_id rate content).freeze
  belongs_to :user
  belongs_to :request
  scope :by_request_ids, ->(request_ids){where(request_id: request_ids)}
  scope :ordered_by_review_time, ->{order(created_at: :desc)}
end
