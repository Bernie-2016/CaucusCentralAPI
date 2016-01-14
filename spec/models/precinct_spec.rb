require 'rails_helper'

describe Precinct do
  describe 'when saved' do
    before(:each) { subject.save }

    it { expect(subject.errors[:name].length).to be >= 1 }
  end

  describe '#threshold' do
    let!(:precinct) { Fabricate(:precinct, total_attendees: 100, total_delegates: total_delegates) }

    subject { precinct.threshold }

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
    let!(:precinct) { Fabricate(:precinct, total_attendees: 100, total_delegates: total_delegates, delegate_counts: { sanders: bernie_supporters }) }

    subject { precinct.above_threshold? }

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
end
