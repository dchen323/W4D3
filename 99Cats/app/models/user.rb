class User < ApplicationRecord
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :session_token, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  before_validation :ensure_session_token
  attr_reader :password
  
  has_many :cat_rental_requests,
  class_name: :CatRentalRequest,
  dependent: :destroy
  
  has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat,
    dependent: :destroy
  
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end
  
end