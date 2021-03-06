require 'rails_helper'

describe Report do
  describe '#threshold' do
    let!(:report) { Fabricate(:report, total_attendees: 100, precinct: Fabricate(:precinct, total_delegates: total_delegates)) }

    subject { report.threshold }

    context 'with 1 delegate' do
      let(:total_delegates) { 1 }

      it 'is 50' do
        expect(subject).to eq(50)
      end
    end

    context 'with 2 delegates' do
      let(:total_delegates) { 2 }

      it 'is 25' do
        expect(subject).to eq(25)
      end
    end

    context 'with 3 delegates' do
      let(:total_delegates) { 3 }

      it 'is 17' do
        expect(subject).to eq(17)
      end
    end

    context 'with 4 delegates' do
      let(:total_delegates) { 4 }

      it 'is 15' do
        expect(subject).to eq(15)
      end
    end
  end

  describe '#above_threshold?' do
    let!(:report) { Fabricate(:report, total_attendees: 100, delegate_counts: { sanders: bernie_supporters }, precinct: Fabricate(:precinct, total_delegates: total_delegates)) }

    subject { report.above_threshold?(:sanders) }

    context 'with 2 delegates' do
      let(:total_delegates) { 2 }

      context 'above threshold' do
        let(:bernie_supporters) { 30 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'below threshold' do
        let(:bernie_supporters) { 20 }

        it 'returns true' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'with 3 delegates' do
      let(:total_delegates) { 3 }

      context 'above threshold' do
        let(:bernie_supporters) { 18 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'below threshold' do
        let(:bernie_supporters) { 15 }

        it 'returns true' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'with 4 delegates' do
      let(:total_delegates) { 4 }

      context 'above threshold' do
        let(:bernie_supporters) { 20 }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'below threshold' do
        let(:bernie_supporters) { 10 }

        it 'returns true' do
          expect(subject).to eq(false)
        end
      end
    end
  end

  describe '#candidate_delegates' do
    let(:results_counts) { {} }
    let!(:report) { Fabricate(:report, total_attendees: 100, delegate_counts: { sanders: sanders_supporters, clinton: 100 - sanders_supporters }, results_counts: results_counts, precinct: Fabricate(:precinct, total_delegates: 10)) }

    subject { report.candidate_delegates(:sanders) }

    context 'with candidate not viable' do
      let(:sanders_supporters) { 14 }

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'with results count' do
      let(:sanders_supporters) { 75 }
      let(:results_counts) { { sanders: 1 } }

      it 'returns results count' do
        expect(subject).to eq(1)
      end
    end

    context 'without results count' do
      let(:sanders_supporters) { 76 }

      it 'returns calculated results' do
        expect(subject).to eq(8)
      end
    end

    context 'when below threshold but previously viable' do
      let!(:captain) { Fabricate(:user) }
      let!(:precinct) { Fabricate(:precinct, total_delegates: 10) }
      let!(:old_report) { Fabricate(:apportionment_report, precinct: precinct, total_attendees: 100, user: captain, delegate_counts: { sanders: 30 }) }
      let!(:report) { Fabricate(:apportioned_report, precinct: precinct, total_attendees: 100, user: captain, delegate_counts: { sanders: 1, clinton: 75, omalley: 24 }) }

      it 'returns 1 delegate' do
        expect(subject).to eq(1)
      end

      it 'takes the delegate from the next lowest candidate' do
        expect(report.candidate_delegates(:omalley)).to eq(1)
        expect(report.candidate_delegates(:clinton)).to eq(8)
      end
    end
  end
end
