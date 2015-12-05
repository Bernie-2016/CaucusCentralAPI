class UserSerializer < ActiveModel::Serializer
  attributes :email, :token

  def token
    "#{object.id}:#{object.auth_token}"
  end
end
