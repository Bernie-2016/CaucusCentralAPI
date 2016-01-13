require 'rails_helper'

describe Api::V1::StatesController do
  describe '#index' do
    let(:states) { State.all }

    subject { get :index }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      it 'returns all states' do
        expect(JSON.parse(subject.body)['states'].length).to eq(13)
      end

      it 'returns details for each state' do
        expect(subject.body).to include_json(
          states: [{
            name: states.first.name,
            code: states.first.code,
            caucus_date: states.first.caucus_date.to_s
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
    let(:state) { State.find_by_code('IA') }

    subject { get :show, id: 'IA' }

    context 'user is organizer' do
      before { login Fabricate(:organizer) }

      it 'returns details for state' do
        expect(subject.body).to include_json(
          state: {
            name: state.name,
            code: state.code,
            caucus_date: state.caucus_date.to_s
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
end
