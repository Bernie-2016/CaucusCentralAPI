require 'rails_helper'
require 'auth_helper'

RSpec.describe SessionsController, type: :controller do
  include AuthHelper

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'confirmed user' do
    let!(:user) { Fabricate(:confirmed_user) }

    before(:each) do
      http_login(user)
    end

    describe '#create' do
      it 'should return an auth token given a valid password' do
        post(
          :create,
          format: :json,
          user_login: { email: user.email, password: user.password }
        )

        expect(response).to be_successful

        body = JSON.parse(response.body)

        expect(body['token']).to eq("#{user.id}:#{user.auth_token}")
      end

      it 'should fail without a valid password' do
        post(
          :create,
          format: :json,
          user_login: { email: user.email, password: 'verywrongpassword' }
        )

        expect(response).to_not be_successful
        expect(response.status).to eq(401)

        body = JSON.parse(response.body)

        expect(body['message']).to eq('Incorrect email and/or password')
      end

      it 'should fail if the request is malformed' do
        post(
          :create,
          format: :json,
          blahblah: { someone: 'thisiswhoiam', letmein: 'lalallaa' }
        )

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        body = JSON.parse(response.body)

        expect(body['message']).to eq('Malformed request')
      end
    end

    describe '#destroy' do
      it 'should be successful' do
        delete(:destroy, format: :json)

        expect(response).to be_successful
      end
    end
  end
end
