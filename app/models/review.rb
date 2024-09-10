class Review < ApplicationRecord
  REVIEWS_PERMITTED = %i(user_id request_id rate content).freeze
  belongs_to :user
  belongs_to :request
  has_one :room, through: :request
  has_one :room_type, through: :request
  enum status: {pending: 0, accepted: 1, rejected: 2}

  ransacker :created_at, type: :date do
    Arel.sql("date(created_at)")
  end

  scope :high_rating, ->{where("rate >= ?", Settings.scope.ratehigh)}
  scope :recent, ->{where("created_at >= ?", Settings.scope.recent.month.ago)}
  scope :by_request_ids, ->(request_ids){where(request_id: request_ids)}
  scope :ordered_by_review_time, ->{order(created_at: :desc)}

  class << self
    def ransackable_attributes _auth_object = nil
      %w(rate content status created_at updated_at)
    end

    def ransackable_associations _auth_object = nil
      %w(user request room room_type)
    end

    def ransackable_scopes _auth_object = nil
      %i(high_rating recent)
    end

    def get_review_available_ids room_type, room_number, status
      Review.by_room_type(room_type)
            .by_room_number(room_number)
            .by_status(status)
    end
  end
end
