require 'rails_helper'

describe Api::V1::PrecinctsController do
  let!(:organizer) { Fabricate(:organizer) }
  let!(:captain) { Fabricate(:captain) }

  describe '#index' do
    subject { get :index }

    context 'user is organizer' do
      let!(:precincts) { Fabricate.times(10, :precinct) }

      before { login organizer }

      it 'returns all precincts' do
        expect(JSON.parse(subject.body)['precincts'].length).to eq(12) # 10 plus 1 for each user
      end

      it 'returns details for each precinct' do
        expect(subject.body).to include_json(
          precincts: [{
            id: Precinct.first.id,
            name: Precinct.first.name,
            county: Precinct.first.county,
            total_delegates: Precinct.first.total_delegates
          }]
        )
      end
    end

    context 'user is captain' do
      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#show' do
    let!(:precinct) { Fabricate(:precinct) }

    subject { get :show, id: precinct.id }

    context 'user is organizer' do
      before { login organizer }

      it 'returns details for precinct' do
        expect(subject.body).to include_json(
          precinct: {
            id: precinct.id,
            name: precinct.name,
            county: precinct.county,
            total_delegates: precinct.total_delegates
          }
        )
      end
    end

    context 'user is captain' do
      before { login captain }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#begin' do
    let(:user) { nil }
    let!(:precinct) { Fabricate(:precinct) }
    let!(:report) { Fabricate(:report, precinct: precinct, user: user) }
    let(:params) { { total_attendees: 250 } }

    subject { post :begin, precinct_id: precinct.id, precinct: params }

    before { login user }

    context 'user is organizer' do
      let(:user) { organizer }

      context 'with valid params' do
        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.total_attendees).to eq(250)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              reports: [{
                total_attendees: 250
              }]
            }
          )
        end
      end
    end

    context 'user is captain' do
      let(:user) { captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.total_attendees).to eq(250)
        end
      end

      context 'user does not own precinct' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end

  describe '#viability' do
    let(:user) { nil }
    let!(:precinct) { Fabricate(:precinct, total_delegates: 5) }
    let!(:report) { Fabricate(:viability_report, precinct: precinct, user: user, total_attendees: 250) }
    let(:params) { { delegate_counts: [{ key: 'sanders', supporters: 75 }] } }

    subject { post :viability, precinct_id: precinct.id, precinct: params }

    before { login user }

    context 'user is organizer' do
      let(:user) { organizer }

      context 'with valid params' do
        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.delegate_counts[:sanders]).to eq(75)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              reports: [{
                phase: 'apportionment',
                delegate_counts: [{
                  key: 'sanders',
                  name: 'Bernie Sanders',
                  supporters: 75
                }]
              }]
            }
          )
        end
      end
    end

    context 'user is captain' do
      let(:user) { captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.delegate_counts[:sanders]).to eq(75)
        end
      end

      context 'user does not own precinct' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end

  describe '#apportionment' do
    let(:user) { nil }
    let!(:precinct) { Fabricate(:precinct, total_delegates: 5) }
    let!(:report) { Fabricate(:apportionment_report, precinct: precinct, user: user, total_attendees: 250) }
    let(:params) { { delegate_counts: [{ key: 'sanders', supporters: 130 }] } }

    subject { post :apportionment, precinct_id: precinct.id, precinct: params }

    before { login user }

    context 'user is organizer' do
      let(:user) { organizer }

      context 'with valid params' do
        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.delegate_counts[:sanders]).to eq(130)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              reports: [{
                phase: 'apportioned',
                delegate_counts: [{
                  key: 'sanders',
                  name: 'Bernie Sanders',
                  supporters: 130,
                  delegates_won: 3
                }]
              }]
            }
          )
        end
      end
    end

    context 'user is captain' do
      let(:user) { captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct report' do
          expect(subject).to have_http_status(200)
          expect(report.reload.delegate_counts[:sanders]).to eq(130)
        end
      end

      context 'user does not own precinct' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end

  describe '#update' do
    let!(:precinct) { Fabricate(:precinct, total_delegates: 5) }
    let(:params) { {} }

    subject { patch :update, id: precinct.id, precinct: params }

    context 'user is organizer' do
      before { login organizer }

      context 'with valid params' do
        let(:params) { { total_delegates: 10 } }

        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.total_delegates).to eq(10)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              total_delegates: 10
            }
          )
        end
      end
    end

    context 'user is captain' do
      before { login captain }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end
end
