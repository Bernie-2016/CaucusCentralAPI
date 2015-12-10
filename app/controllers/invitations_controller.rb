class InvitationsController < Devise::InvitationsController
  prepend_before_filter :authenticate_user_from_token!

  def create
    invited = send_invitation!
    return invalid_invitation_attempt(invited) if invited.errors.any?
    render(json: { result: :success })
  end

  private

  def send_invitation!
    User.invite!(
      email: params.fetch(:email),
      first_name: params[:first_name],
      last_name: params[:last_name]
    )
  end

  def invalid_invitation_attempt(invited)
    render(json: { errors: invited.errors.messages }, status: 406)
  end
end
