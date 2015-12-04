class ApplicationController < ActionController::API
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
