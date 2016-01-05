class UserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :email, :token

  def token
    object.tokens.first.try(:token)
  end
end
