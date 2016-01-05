module AuthHelper
  def login(user = Fabricate(:user))
    request.headers['Authorization'] = Fabricate(:token, user: user).token
  end
end
