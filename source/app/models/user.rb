class User < ActiveRecord::Base
  attr_accessor :password

  before_save :encrypt_password

  validates :password, presence: { on: :create }, confirmation: true
  validates :email, presence: true, uniqueness: true

  def self.authenticate(email, password)
    user = find_by_email(email)
    user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
