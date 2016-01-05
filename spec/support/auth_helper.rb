module AuthHelper
  def http_login(user)
    id = user.id
    token = user.auth_token
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(id, token)
  end
end
