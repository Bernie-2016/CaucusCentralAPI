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
            supporting_attendees: precincts.first.supporting_attendees,
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
            supporting_attendees: precinct.supporting_attendees,
            total_attendees: precinct.total_attendees
          }
        )
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject.code).to eq('403')
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
          expect(subject.code).to eq('201')
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
          expect(subject.code).to eq('422')
        end
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject.code).to eq('403')
      end
    end
  end
end
