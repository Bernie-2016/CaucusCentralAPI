require 'rails_helper'

RSpec.describe "Precincts", type: :request do
  describe "GET /precincts" do
    it "works! (now write some real specs)" do
      get api_v1_precincts_path
      expect(response).to have_http_status(200)
    end
  end
end
