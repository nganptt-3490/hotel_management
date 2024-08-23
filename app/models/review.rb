class Review < ApplicationRecord
  REVIEWS_PERMITTED = %i(user_id request_id rate content).freeze
  belongs_to :user
  belongs_to :request
  enum status: {pending: 0, accepted: 1, rejected: 2}
  scope :by_request_ids, ->(request_ids){where(request_id: request_ids)}
  scope :ordered_by_review_time, ->{order(created_at: :desc)}
end
