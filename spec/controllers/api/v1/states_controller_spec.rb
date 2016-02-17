require 'rails_helper'

describe Api::V1::StatesController do
  describe '#index' do
    let(:states) { State.all }

    subject { get :index }

    context 'user is admin' do
      before { login Fabricate(:admin) }

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

    context 'user is admin' do
      before { login Fabricate(:admin) }

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

  describe '#csv' do
    let(:state) { State.find_by_code('IA') }
    let(:token) { nil }

    subject { get :csv, state_id: 'IA', token: token }

    context 'user is admin' do
      let!(:token) { Fabricate(:token, user: Fabricate(:admin)).token }

      context 'with no microsoft report' do
        it 'returns CSV with placeholders' do
          pending 'update for new csv'
          csv_rows = subject.body.split("\n")
          expect(csv_rows[0]).to eq('county,precinct,total_delegates,sanders_delegates,clinton_delegates,omalley_delegates,uncommitted_delegates')
          p = state.precincts.first
          first_row = "#{p.county},#{p.name},#{p.total_delegates},N/A,N/A,N/A,N/A"
          expect(csv_rows[1]).to eq(first_row)
        end
      end

      context 'with microsoft report' do
        before { Fabricate(:report, precinct: state.precincts.first, source: :microsoft, results_counts: { sanders: 5, clinton: 2, omalley: 3, uncommitted: 1 }) }

        it 'returns CSV with placeholders' do
          pending 'update for new csv'
          csv_rows = subject.body.split("\n")
          expect(csv_rows[0]).to eq('county,precinct,total_delegates,sanders_delegates,clinton_delegates,omalley_delegates,uncommitted_delegates')
          p = state.precincts.first
          first_row = "#{p.county},#{p.name},#{p.total_delegates},5,2,3,1"
          expect(csv_rows[1]).to eq(first_row)
        end
      end
    end

    context 'user is captain' do
      let!(:token) { Fabricate(:token, user: Fabricate(:captain)).token }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end
end
