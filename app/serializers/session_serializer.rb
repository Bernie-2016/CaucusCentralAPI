class SessionSerializer < JsonSerializer
  class << self
    def root_hash(token, _options = {})
      node = UserSerializer.hash(token.user)
      node[:token] = token.token
      { user: node }
    end
  end
end
