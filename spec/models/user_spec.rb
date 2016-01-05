require 'rails_helper'

describe User do
  context 'when creating a new user' do
    subject(:user) { Fabricate(:confirmed_user) }

    it 'should have an auth token' do
      expect(user.auth_token).to_not be_blank
    end
  end
end
