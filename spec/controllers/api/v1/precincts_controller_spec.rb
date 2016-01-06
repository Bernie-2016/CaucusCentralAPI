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
            total_attendees: precincts.first.total_attendees
          }]
        )
      end
    end

    context 'user is captain' do
      let!(:precincts) { Fabricate.times(5, :precinct) }
      let!(:captain) do
        Fabricate(:captain) do
          precincts { Fabricate.times(5, :precinct) }
        end
      end

      before { login captain }

      it 'returns only their precincts' do
        expect(JSON.parse(subject.body)['precincts'].length).to eq(5)
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
            total_attendees: precinct.total_attendees
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

  describe '#create' do
    let(:params) { { name: 'Des Moines 1', county: 'Polk' } }

    subject { post :create, precinct: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'creates the precinct' do
          expect(subject).to have_http_status(201)
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 1',
              county: 'Polk'
            }
          )
        end
      end

      context 'with invalid params' do
        let(:params) { { name: 'Des Moines 1' } }

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

  describe '#update' do
    let!(:precinct) { Fabricate(:precinct, name: 'Des Moines 1', county: 'Polk') }
    let(:params) { { name: 'Des Moines 2', delegate_counts: [{ key: 'sanders', supporters: 25 }] } }

    subject { patch :update, id: precinct.id, precinct: params }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      context 'with valid params' do
        it 'updates the precinct' do
          expect(subject).to have_http_status(200)
          expect(precinct.reload.name).to eq('Des Moines 2')
        end

        it 'returns the precinct' do
          expect(subject.body).to include_json(
            precinct: {
              name: 'Des Moines 2',
              county: 'Polk',
              delegate_counts: [{
                key: 'sanders',
                name: 'Bernie Sanders',
                supporters: 25
              }]
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
          expect(precinct.reload.name).to eq('Des Moines 2')
        end
      end

      context 'user does not own precinct' do
        it 'returns unauthorized' do
          expect(subject).to have_http_status(403)
        end
      end
    end
  end

  describe '#destroy' do
    let!(:precinct) { Fabricate(:precinct) }

    subject { delete :destroy, id: precinct.id }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      it 'returns 204' do
        expect(subject).to have_http_status(204)
      end

      it 'destroys the precinct' do
        expect { subject }.to change { Precinct.count }.by(-1)
      end
    end

    context 'user is captain' do
      let!(:captain) { Fabricate(:captain) }

      before { login captain }

      context 'user owns precinct' do
        before { precinct.users << captain }

        it 'returns 204' do
          expect(subject).to have_http_status(204)
        end

        it 'destroys the precinct' do
          expect { subject }.to change { Precinct.count }.by(-1)
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
