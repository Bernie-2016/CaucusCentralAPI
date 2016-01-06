class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'

  validates :email, presence: true, format: /\A[^@]+@[^@]+\z/, allow_blank: false
  validate :recipient_not_registered
  
  before_create :generate_token!

  after_create :send_invite

  private

  def recipient_not_registered
    self.errors[:email] << 'has already been invited' if User.exists?(email: email)
  end

  def generate_token!
    return unless token.blank?
    loop do
      self.token = SecureRandom.hex(32)
      break token unless Invitation.exists?(token: token)
    end
  end

  def send_invite
    ApplicationMailer.invite(id).deliver_now
  end
end
