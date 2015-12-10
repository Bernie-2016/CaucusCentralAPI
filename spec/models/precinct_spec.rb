require 'rails_helper'

RSpec.describe Precinct, type: :model do
  describe "when saved" do
    before(:each) { subject.save }
    it { expect(subject.errors[:name].length).to be >= 1 }
  end
end
