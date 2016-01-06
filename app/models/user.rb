class User < ActiveRecord::Base
  has_secure_password

  belongs_to :precinct
  has_many :tokens, dependent: :destroy

  default_scope -> { order(last_name: :asc) }

  validates :email, :first_name, :last_name, presence: true, allow_blank: false

  enum privilege: [:unassigned, :captain, :organizer]
end
