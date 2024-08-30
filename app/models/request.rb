class Request < ApplicationRecord
  include RoomTypesHelper

  belongs_to :user
  belongs_to :room, optional: true
  belongs_to :room_type
  has_many :lost_utilities, dependent: :destroy
  has_many :room_costs, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :histories, dependent: :destroy

  ATTRIBUTE_PERMITTED = %i(start_date end_date room_type_id).freeze

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :validate_dates

  def validate_dates
    return if room_available?

    errors.add(:base, I18n.t("request.not_available"))
  end

  def room_available?
    available_room_type_ids = get_room_type_available_ids(start_date, end_date)
    available_room_type_ids.include?(room_type_id)
  end

  scope :accepted, lambda {|_x = nil|
    joins(:histories)
      .where(histories: {id: History.latest_id(subquery: :request_id)})
      .merge(History.with_status(:accepted))
  }

  scope :within_date_range, lambda {|start_date, end_date|
    where("(start_date BETWEEN :start_date AND :end_date)
          OR (end_date BETWEEN :start_date AND :end_date)",
          start_date:, end_date:)
  }
  scope :with_start_date, lambda {|start_date|
    where(":start_date BETWEEN start_date AND end_date", start_date:)
  }
  scope :with_end_date, lambda {|end_date|
    where(":end_date BETWEEN start_date AND end_date", end_date:)
  }
  scope :by_room_type, ->(room_type_id){where(room_type_id:)}
  scope :sorted_by_date, ->{order(start_date: :desc, created_at: :desc)}

  scope :order_by_created_at_desc, ->{order(created_at: :desc)}
end
