require "rails_helper"

RSpec.describe PrecinctsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/precincts").to route_to("precincts#index")
    end

    it "routes to #show" do
      expect(:get => "/precincts/1").to route_to("precincts#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/precincts").to route_to("precincts#create")
    end

    it "routes to #update" do
      expect(:put => "/precincts/1").to route_to("precincts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/precincts/1").to route_to("precincts#destroy", :id => "1")
    end

  end
end
