class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'no-reply@berniesanders.com'

  def invite(invitation_id)
    @invitation = Invitation.find invitation_id
    mail to: @invitation.email, subject: 'Invitation to Caucus Central'
  end

  def reset(user_id, token)
    @token = token
    @user = User.find user_id
    mail to: @user.email, subject: 'Caucus Central Password Reset'
  end
end
