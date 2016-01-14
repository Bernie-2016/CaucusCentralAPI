require 'rails_helper'

describe Token do
  context 'when creating a new token' do
    subject(:token) { Fabricate(:token) }

    it 'should have an auth token' do
      expect(token.token).not_to be_blank
    end
  end
end
