require 'rails_helper'

describe MicrosoftDataService do
  before { stub_request(:get, 'https://www.idpcaucuses.com/api/PrecinctCandidateResults').to_return(body: Rails.root.join('spec', 'fixtures', 'microsoft.json')) }

  subject { MicrosoftDataService.perform! }

  context 'when precinct with exact name exists' do
    let!(:precinct) { Fabricate(:precinct, county: 'ADAMS', name: 'Adams-Adams 3') }

    it 'creates report' do
      expect { subject }.to change { precinct.reports.microsoft.count }.by(1)
    end

    context 'after completion' do
      before { subject }

      let(:report) { precinct.reports.microsoft.first }

      it 'stores candidate totals' do
        expect(report.results_counts[:sanders]).to eq(7)
      end
    end
  end

  context 'when precinct with matching number exists' do
    let!(:precinct) { Fabricate(:precinct, county: 'JACKSON', name: 'Jackson-Bellevue Community Center - Pct 1') }

    it 'creates report' do
      expect { subject }.to change { precinct.reports.microsoft.count }.by(1)
    end

    context 'after completion' do
      before { subject }

      let(:report) { precinct.reports.microsoft.first }

      it 'stores candidate totals' do
        expect(report.results_counts[:clinton]).to eq(8)
      end
    end
  end
end
