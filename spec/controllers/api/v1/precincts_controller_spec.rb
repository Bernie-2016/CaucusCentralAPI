require 'rails_helper'

describe Api::V1::PrecinctsController do
  describe '#index' do
    subject { get :index }

    context 'user is organizer' do
      let!(:precincts) { Fabricate.times(10, :precinct) }

      before { login Fabricate(:organizer) }

      it 'returns all precincts' do
        expect(JSON.parse(subject.body)['precincts'].length).to eq(10)
      end

      it 'returns details for each precinct' do
        expect(subject.body).to include_json(
          precincts: [{
            id: precincts.first.id,
            name: precincts.first.name,
            county: precincts.first.county,
            total_attendees: precincts.first.total_attendees,
            total_delegates: precincts.first.total_delegates
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
      before { login Fabricate(:organizer) }

      it 'returns details for precinct' do
        expect(subject.body).to include_json(
          precinct: {
            id: precinct.id,
            name: precinct.name,
            county: precinct.county,
            total_attendees: precinct.total_attendees,
            total_delegates: precinct.total_delegates
          }
        )
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#begin' do
    let!(:precinct) { Fabricate(:precinct, total_attendees: 0, total_delegates: 5) }
    let(:params) { { total_attendees: 250 } }

    subject { post :begin, precinct_id: precinct.id, precinct: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.total_attendees).to eq(250)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              phase: 'viability'
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

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.total_attendees).to eq(250)
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
    let!(:precinct) { Fabricate(:viability_precinct, total_attendees: 250, total_delegates: 5) }
    let(:params) { { delegate_counts: [{ key: 'sanders', supporters: 75 }] } }

    subject { post :viability, precinct_id: precinct.id, precinct: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.delegate_counts[:sanders]).to eq(75)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              phase: 'apportionment',
              is_viable: true,
              delegate_counts: [{
                key: 'sanders',
                name: 'Bernie Sanders',
                supporters: 75
              }]
            }
          )
        end
      end
    end

    context 'user is captain' do
      let!(:captain) { Fabricate(:captain) }

      before { login captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.delegate_counts[:sanders]).to eq(75)
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
    let!(:precinct) { Fabricate(:apportionment_precinct, total_attendees: 250, total_delegates: 5) }
    let(:params) { { delegate_counts: [{ key: 'sanders', supporters: 130 }] } }

    subject { post :apportionment, precinct_id: precinct.id, precinct: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.delegate_counts[:sanders]).to eq(130)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk',
              phase: 'apportioned',
              is_viable: true,
              delegate_counts: [{
                key: 'sanders',
                name: 'Bernie Sanders',
                supporters: 130,
                delegates_won: 3
              }]
            }
          )
        end
      end
    end

    context 'user is captain' do
      let!(:captain) { Fabricate(:captain) }

      before { login captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.delegate_counts[:sanders]).to eq(130)
        end
      end

      context 'user does not own precinct' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end
end
