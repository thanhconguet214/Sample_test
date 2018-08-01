class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.maximum1}
  validates :email, presence: true, length: {maximum: Settings.maximum2},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.minimum}
  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
          BCrypt::Password.create(string, cost: cost)
    end
  end
end
