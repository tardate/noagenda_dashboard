require "spec_helper"

describe ShowsController do
  describe "routing" do

    it "routes to #index" do
      get("/shows").should route_to("shows#index")
    end

    it "routes to #show" do
      get("/shows/1").should route_to("shows#show", :id => "1")
    end

  end
end
