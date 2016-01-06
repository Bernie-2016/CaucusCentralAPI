require 'rails_helper'

describe Api::V1::InvitationsController do
  shared_examples 'returns unauthorized' do
    it 'returns 403' do
      expect(subject).to have_http_status(403)
    end
  end

  describe '#create' do
    let(:params) { { email: 'bernie@berniesanders.com' } }

    subject { post :create, params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'creates the invitation' do
          expect(subject).to have_http_status(201)
        end

        it 'returns the invitation' do
          expect(subject.body).to include_json(
            invitation: {
              email: 'bernie@berniesanders.com'
            }
          )
        end
      end

      context 'with invalid params' do
        let(:params) { { email: 'not.an.email' } }

        it 'returns unprocessable' do
          expect(subject).to have_http_status(422)
        end
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end
end
