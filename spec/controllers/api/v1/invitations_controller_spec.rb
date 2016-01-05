require 'rails_helper'
require 'auth_helper'

describe Api::V1::InvitationsController, type: :controller do
  include AuthHelper

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'as a user' do
    let!(:user) { Fabricate(:confirmed_user) }

    before(:each) do
      http_login(user)
    end

    context 'valid invitation' do
      describe '#create' do
        it 'should return success' do
          post(
            :create,
            format: :json,
            email: 'user@example.com',
            first_name: 'bobby',
            last_name: 'jindall'
          )

          expect(response).to be_successful
          body = JSON.parse(response.body)
          expect(body['result']).to eq('success')
        end
      end
    end
    context 'invalid invitation' do
      describe '#create' do
        it 'should fail' do
          post(
            :create,
            format: :json,
            email: ''
          )

          expect(response.status).to eq(406)
          body = JSON.parse(response.body)
          expect(body['errors']).to eq('email' => ["can't be blank"])
        end
      end
    end
  end
end
