require 'rails_helper'

describe Precinct do
  describe 'when saved' do
    before { subject.save }

    it { expect(subject.errors[:name].length).to be >= 1 }
  end
end
