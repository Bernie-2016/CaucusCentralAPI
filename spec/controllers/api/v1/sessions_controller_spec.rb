require 'rails_helper'

describe Api::V1::SessionsController do
  let!(:user) { Fabricate(:user, email: 'john@smith.com', password: 'password', password_confirmation: 'password') }

  describe '#create' do
    subject { post :create, credentials }

    context 'with valid credentials' do
      let(:credentials) { { email: 'john@smith.com', password: 'password' } }

      it 'returns 200' do
        expect(subject).to have_http_status(200)
      end

      it 'returns success message, token, and user info' do
        expect(subject.body).to include_json(
          user: {
            token: user.reload.tokens.first.token,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          }
        )
      end

      it 'logs in the user' do
        expect { subject }.to change { user.tokens.count }.by(1)
      end
    end

    context 'with invalid credentials' do
      let(:credentials) { { email: 'john@smith.com', password: 'wrong' } }

      it 'returns 403' do
        expect(subject).to have_http_status(403)
      end

      it 'does not log in the user' do
        expect { subject }.to change { user.tokens.count }.by(0)
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy }

    context 'with no user logged in' do
      let(:token) { nil }

      it 'returns 403' do
        expect(subject).to have_http_status(403)
      end
    end

    context 'with user logged in' do
      let(:token) { Fabricate(:token, user: user) }
      before { request.headers['Authorization'] = token.token }

      it 'returns 200' do
        expect(subject).to have_http_status(200)
      end

      it 'destroys the token' do
        expect { subject }.to change { user.tokens.count }.by(-1)
      end
    end
  end
end
