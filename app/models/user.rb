class User < ActiveRecord::Base
  has_secure_password

  belongs_to :precinct
  has_many :tokens, dependent: :destroy
  belongs_to :invitation

  default_scope -> { order(last_name: :asc) }

  validates :email, :first_name, :last_name, presence: true, allow_blank: false
  validates :invitation, presence: true, uniqueness: { message: 'has already been redeemed' }, unless: :organizer?

  enum privilege: [:unassigned, :captain, :organizer]

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
    self.privilege = invitation.privilege if invitation
  end
end
