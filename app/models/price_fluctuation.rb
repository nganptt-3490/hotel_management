class PriceFluctuation < ApplicationRecord
  ATTRIBUTE_PERMITTED = %i(name start_date end_date rate).freeze
  has_many :room_costs, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :rate, presence: true

  scope :search_by_name, lambda {|name|
    where("name LIKE ?", "%#{name}%") if name.present?
  }
end
