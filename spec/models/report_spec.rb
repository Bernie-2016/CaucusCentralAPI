require 'rails_helper'

describe Report do
  describe '#threshold' do
    let!(:report) { Fabricate(:report, total_attendees: 100, precinct: Fabricate(:precinct, total_delegates: total_delegates)) }

    subject { report.threshold }

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

    subject { report.above_threshold? }

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
    let!(:report) { Fabricate(:report, total_attendees: 100, delegate_counts: { sanders: 75 }, results_counts: results_counts, precinct: Fabricate(:precinct, total_delegates: 5)) }

    subject { report.candidate_delegates(:sanders) }

    context 'with results count' do
      let(:results_counts) { { sanders: 1 } }

      it 'returns results count' do
        expect(subject).to eq(1)
      end
    end

    context 'without results count' do
      it 'returns calculated results' do
        expect(subject).to eq(4)
      end
    end
  end
end
