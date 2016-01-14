require 'rails_helper'

describe Api::V1::UsersController do
  shared_examples 'returns unauthorized' do
    it 'returns 403' do
      expect(subject).to have_http_status(403)
    end
  end

  describe '#index' do
    let!(:users) { Fabricate.times(10, :user) }

    subject { get :index }

    context 'user is an organizer' do
      before { login Fabricate(:organizer) }
      it 'returns all users' do
        expect(JSON.parse(subject.body)['users'].length).to eq(11)
      end

      it 'returns details for each user' do
        expect(subject.body).to include_json(
          users: [{
            id: users.first.id,
            first_name: users.first.first_name,
            last_name: users.first.last_name,
            email: users.first.email,
            privilege: users.first.privilege
          }]
        )
      end
    end

    context 'user is a captain' do
      before { login Fabricate(:captain) }

      it_behaves_like 'returns unauthorized'
    end
  end

  describe '#show' do
    let!(:user) { Fabricate(:user) }

    subject { get :show, id: user.id }

    context 'user is an organizer' do
      before { login Fabricate(:organizer) }

      it 'returns details for user' do
        expect(subject.body).to include_json(
          user: {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            privilege: user.privilege
          }
        )
      end
    end

    context 'user is a captain' do
      let!(:captain) { Fabricate(:captain) }
      before { login captain }

      context 'requested user is current user' do
        let(:user) { captain }

        it 'returns details for user' do
          expect(subject.body).to include_json(
            user: {
              id: user.id,
              first_name: user.first_name,
              last_name: user.last_name,
              email: user.email,
              privilege: user.privilege
            }
          )
        end
      end

      context 'requested user is not current user' do
        it_behaves_like 'returns unauthorized'
      end
    end
  end

  describe '#profile' do
    let!(:user) { Fabricate(:user) }

    before { login user }

    subject { get :profile }

    it 'returns details for user' do
      expect(subject.body).to include_json(
        user: {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          privilege: user.privilege
        }
      )
    end
  end

  describe '#create' do
    let!(:invitation) { Fabricate(:invitation) }
    let(:params) { { first_name: 'Bernie', last_name: 'Sanders', email: 'bernie@berniesanders.com', password: 'password', password_confirmation: 'password', privilege: 'captain', invitation_token: invitation.token } }

    subject { post :create, user: params }

    context 'with valid params' do
      before { request.headers['Authorization'] = invitation.token }

      it 'creates the user' do
        expect(subject).to have_http_status(201)
      end

      it 'returns the user' do
        expect(subject.body).to include_json(
          user: {
            first_name: 'Bernie',
            last_name: 'Sanders',
            email: 'bernie@berniesanders.com',
            privilege: 'captain'
          }
        )
      end
    end

    context 'with invalid params' do
      before { request.headers['Authorization'] = invitation.token }

      let(:params) { { first_name: 'Bernie' } }

      it 'returns unprocessable' do
        expect(subject).to have_http_status(422)
      end
    end

    context 'without an invitation token' do
      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#update' do
    let!(:user) { Fabricate(:user, first_name: 'Bernie') }
    let(:params) { { first_name: 'Bernard' } }

    subject { patch :update, id: user.id, user: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'updates the user' do
          expect(subject).to have_http_status(200)
          expect(user.reload.first_name).to eq('Bernard')
        end

        it 'returns the user' do
          expect(subject.body).to include_json(
            user: {
              first_name: 'Bernard'
            }
          )
        end
      end

      context 'with invalid params' do
        let(:params) { {} }

        it 'returns unprocessable' do
          expect(subject).to have_http_status(422)
        end
      end
    end

    context 'user is captain' do
      let!(:captain) { Fabricate(:captain) }

      before { login captain }

      context 'user is captain' do
        let(:user) { captain }

        it 'updates the user' do
          expect(subject).to have_http_status(200)
          expect(user.reload.first_name).to eq('Bernard')
        end
      end

      context 'user is not captain' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end

  describe '#update_profile' do
    let!(:user) { Fabricate(:user, first_name: 'Bernie') }

    before { login user }

    subject { patch :update_profile, user: { first_name: 'Bernard' } }

    it 'updates the user' do
      expect(subject).to have_http_status(200)
      expect(user.reload.first_name).to eq('Bernard')
    end
  end

  describe '#destroy' do
    let!(:user) { Fabricate(:user) }

    subject { delete :destroy, id: user.id }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      it 'returns 204' do
        expect(subject).to have_http_status(204)
      end

      it 'destroys the user' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end

    context 'user is captain' do
      let!(:captain) { Fabricate(:captain) }

      before { login captain }

      context 'user is captain' do
        let(:user) { captain }

        it 'returns 204' do
          expect(subject).to have_http_status(204)
        end

        it 'destroys the user' do
          expect { subject }.to change { User.count }.by(-1)
        end
      end

      context 'user is not captain' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end
end
