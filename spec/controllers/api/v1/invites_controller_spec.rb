require 'rails_helper'

describe Api::V1::InvitationsController do
  shared_examples 'returns unauthorized' do
    it 'returns 403' do
      expect(subject).to have_http_status(403)
    end
  end

  describe '#index' do
    let!(:invitations) { Fabricate.times(10, :invitation) }

    subject { get :index }

    context 'user is an organizer' do
      before { login Fabricate(:organizer) }
      it 'returns all invitations' do
        expect(JSON.parse(subject.body)['invitations'].length).to eq(11)
      end

      it 'returns details for each invitation' do
        expect(subject.body).to include_json(
          invitations: [{
            id: Invitation.first.id,
            email: Invitation.first.email,
            privilege: Invitation.first.privilege,
            precinct_id: Invitation.first.precinct_id
          }]
        )
      end
    end

    context 'user is a captain' do
      before { login Fabricate(:captain) }

      it_behaves_like 'returns unauthorized'
    end
  end

  describe '#create' do
    let!(:precinct) { Fabricate(:precinct) }
    let(:params) { { invitation: { email: 'bernie@berniesanders.com', privilege: 'captain', precinct_id: precinct.id } } }

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
              email: 'bernie@berniesanders.com',
              privilege: 'captain',
              precinct_id: precinct.id
            }
          )
        end

        it 'sends mail' do
          expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'includes token in mail' do
          subject
          expect(ActionMailer::Base.deliveries.last.body.encoded).to match(Invitation.find_by(email: 'bernie@berniesanders.com').token)
        end
      end

      context 'with invalid params' do
        let(:params) { { invitation: { email: 'not.an.email' } } }

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

  describe '#resend' do
    let!(:invitation) { Fabricate(:invitation) }

    subject { post :resend, invitation_id: invitation.id }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'invitation exists' do
        it 'sends mail' do
          expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context 'invitation has been redeemed' do
        let!(:user) { Fabricate(:user, invitation: invitation) }

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
