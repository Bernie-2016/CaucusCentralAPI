require "rails_helper"

describe Api::V1::PrecinctsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/precincts").to route_to("api/v1/precincts#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/precincts/1").to route_to("api/v1/precincts#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/precincts").to route_to("api/v1/precincts#create")
    end

    it "routes to #update" do
      expect(:put => "/api/v1/precincts/1").to route_to("api/v1/precincts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/v1/precincts/1").to route_to("api/v1/precincts#destroy", :id => "1")
    end

  end
end
