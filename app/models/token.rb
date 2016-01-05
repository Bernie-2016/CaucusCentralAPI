class Token < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token!

  default_scope -> { order(created_at: :desc) }

  def unexpired?
    created_at > Date.today - 7.days
  end

  private

  def generate_token!
    return unless self.token.blank?
    loop do
      self.token = SecureRandom.hex(128)
      break self.token unless Token.exists?(token: self.token)
    end
  end
end
