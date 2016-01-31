class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :precinct

  has_one :user

  default_scope -> { order(email: :asc) }

  validates :email, presence: true, format: /\A[^@]+@[^@]+\z/, allow_blank: false
  validates :privilege, presence: true
  validate :recipient_not_registered

  before_create :generate_token!

  after_create :send_invite

  enum privilege: [:unassigned, :captain, :organizer]

  def unexpired?
    created_at > Date.today - 14.days
  end

  def send_invite
    ApplicationMailer.invite(id).deliver_now
  end

  private

  def recipient_not_registered
    errors[:email] << 'has already been invited' if User.exists?(email: email) || Invitation.exists?(email: email)
  end

  def generate_token!
    return unless token.blank?
    loop do
      self.token = SecureRandom.hex(32)
      break token unless Invitation.exists?(token: token)
    end
  end
end
