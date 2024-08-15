class User < ApplicationRecord
  enum role: {regular_user: 0, admin: 1}
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy
end
