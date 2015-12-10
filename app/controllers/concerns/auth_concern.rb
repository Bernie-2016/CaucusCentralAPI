module AuthConcern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_from_token!
  end

  def authenticate_user_from_token!
    authenticate_or_request_with_http_basic do |login, token|
      user = User.find(login)

      if user && Devise.secure_compare(user.auth_token, token)
        sign_in(user, store: false)
      else
        auth_error
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end

  def auth_error
    warden.custom_failure! if performed?
    render(json: { error: 'unauthorized' }, status: 401)
  end
end
