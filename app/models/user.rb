class User < ApplicationRecord
  before_save {email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.MAX_NAME_LENGTH}
  validates :email, presence: true,
    length: {maximum: Settings.MAX_EMAIL_LENGTH},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.MIN_PASS}

  has_secure_password
end
