class Review < ApplicationRecord
  REVIEWS_PERMITTED = %i(user_id request_id rate content).freeze
  belongs_to :user
  belongs_to :request
  enum status: {pending: 0, accepted: 1, rejected: 2}
  scope :by_request_ids, ->(request_ids){where(request_id: request_ids)}
  scope :ordered_by_review_time, ->{order(created_at: :desc)}
  scope :by_room_type, lambda {|room_type|
    return if room_type.blank?

    joins(request: :room_type).where("room_types.name LIKE ?", "%#{room_type}%")
  }
  scope :by_room_number, lambda {|room_number|
    return if room_number.blank?

    joins(request: :room).where("rooms.room_number = ?", room_number)
  }
  scope :by_status, lambda {|status|
    where(status:) if status.present?
  }

  def self.get_review_available_ids room_type, room_number, status
    Review.by_room_type(room_type)
          .by_room_number(room_number)
          .by_status(status)
  end
end
