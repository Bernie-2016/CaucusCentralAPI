class User < ActiveRecord::Base
  has_secure_password

  belongs_to :invitation
  belongs_to :precinct
  belongs_to :state
  has_many :reports
  has_many :tokens, dependent: :destroy

  default_scope -> { order(last_name: :asc, first_name: :asc) }

  validates :email, :first_name, :last_name, presence: true, allow_blank: false
  validates :invitation, presence: true, uniqueness: { message: 'has already been redeemed' }, on: :create

  enum privilege: [:unassigned, :captain, :organizer, :admin]

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
    return unless invitation
    self.privilege = invitation.privilege
    self.precinct_id = invitation.precinct_id
    self.state_id = invitation.state_id
  end

  def send_reset!
    token = tokens.create(token_type: :reset)
    ApplicationMailer.delay.reset(id, token.token)
  end
end
