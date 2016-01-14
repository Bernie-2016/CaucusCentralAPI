class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :precinct

  validates :email, presence: true, format: /\A[^@]+@[^@]+\z/, allow_blank: false
  validates :privilege, presence: true
  validate :recipient_not_registered

  before_create :generate_token!

  after_create :send_invite

  enum privilege: [:unassigned, :captain, :organizer]

  def unexpired?
    created_at > Date.today - 7.days
  end

  private

  def recipient_not_registered
    errors[:email] << 'has already been invited' if User.exists?(email: email)
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
