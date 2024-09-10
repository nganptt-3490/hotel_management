class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]
  USER_PERMITTED = %i(username email password password_confirmation).freeze
  before_save :downcase_email

  enum role: {regular_user: 0, admin: 1}
  has_many :reviews, dependent: :destroy
  has_many :requests, dependent: :destroy, class_name: Request.name

  validates :username, presence: true,
                       length: {maximum: Settings.maximum.name}
  validates :email, presence: true,
                    length: {maximum: Settings.maximum.email},
                    format: {with: Settings.regex.email},
                    uniqueness: {case_sensitive: false}

  class << self
    def ransackable_attributes _auth_object = nil
      %w(username)
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost
    end

    def from_omniauth access_token
      data = access_token.info
      user = User.where(email: data["email"]).first

      user ||= User.create(username: data["name"],
                           email: data["email"],
                           password: Devise.friendly_token[0, 20],
                           provider: access_token[:provider],
                           uid: access_token[:uid])
      user
    end
  end

  private
  def downcase_email
    email.downcase!
  end
end
