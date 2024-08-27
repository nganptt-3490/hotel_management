class PriceFluctuation < ApplicationRecord
  has_many :room_costs, dependent: :destroy

  scope :search_by_name, lambda {|name|
    where("name LIKE ?", "%#{name}%") if name.present?
  }
end
