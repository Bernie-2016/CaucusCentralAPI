class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :precincts
  has_many :tokens

  validates :email, :first_name, :last_name, presence: true, allow_blank: false

  enum privilege: [:unassigned, :captain, :organizer]
end
