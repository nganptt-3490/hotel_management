class User < ApplicationRecord
  before_save :downcase_email

  enum role: {regular_user: 0, admin: 1}
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy

  validates :username, presence: true,
                       length: {maximum: Settings.maximum.name}
  validates :email, presence: true,
                    length: {maximum: Settings.maximum.email},
                    format: {with: Settings.regex.email},
                    uniqueness: {case_sensitive: false}

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end
  private
  def downcase_email
    email.downcase!
  end
end
