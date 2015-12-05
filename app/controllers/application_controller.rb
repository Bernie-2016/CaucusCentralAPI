class ApplicationController < ActionController::API
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_from_token!

  respond_to :json

  def authenticate_user_from_token!
    token = request.headers['Authorization']

    if token
      authenticate_with_token(token)
    else
      auth_error
    end
  end


  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end

  def authenticate_with_token(token)
    auth_error and return unless token.include?(':')

    user_id, auth_token = token.split(':')
    user = User.find(user_id)

    if(user && Devise.secure_compare(user.auth_token, auth_token))
      sign_in(user, store: false)
    else
      auth_error
    end
  end

  def auth_error
    render(json: {error: 'unauthorized'}, status: 401)
  end
end
