class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  before_create :ensure_auth_token!

  validates :email, :first_name, :last_name, presence: true, allow_blank: false

  enum privilege: [:unassigned, :captain, :organizer]

  private

  def ensure_auth_token!
    self.auth_token = generate_auth_token if auth_token.blank?
  end

  def generate_auth_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by(auth_token: token)
    end
  end
end
