require 'rails_helper'

describe User do
  context 'when creating a new captain' do
    describe 'with an invitation token' do
      let!(:invitation) { Fabricate(:invitation, privilege: :organizer) }
      subject(:user) { Fabricate(:captain, invitation_token: invitation.token, invitation: nil) }

      it 'assigns the invitation by its token' do
        expect(user.invitation).to eq invitation
      end

      it 'assigns the privilege of its invitation' do
        expect(user.privilege).to eq invitation.privilege
      end
    end

    context 'without an invitation token' do
      subject(:user) { Fabricate.build(:captain, invitation_token: nil, invitation: nil) }

      it 'should not save' do
        subject.save
        expect(subject.errors[:invitation].length).to be >= 1
      end
    end
  end
end
