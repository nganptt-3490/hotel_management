class Request < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :room_type
  has_many :lost_utilities, dependent: :destroy
  has_many :room_costs, dependent: :destroy

  scope :accepted, ->{where.not(accepted_at: nil)}
  scope :within_date_range, lambda {|start_date, end_date|
    where("(start_date BETWEEN :start_date AND :end_date)
          OR (end_date BETWEEN :start_date AND :end_date)",
          start_date:, end_date:)
  }
  scope :with_start_date, ->(start_date) {
    where(":start_date BETWEEN start_date AND end_date", start_date:)
  }
  scope :with_end_date, ->(end_date) {
    where(":end_date BETWEEN start_date AND end_date", end_date:)
  }
end
