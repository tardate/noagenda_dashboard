require "spec_helper"

describe ShowsController do
  describe "routing" do

    it "routes to #index" do
      get("/shows").should route_to("shows#index")
    end

    it "routes to #new" do
      get("/shows/new").should route_to("shows#new")
    end

    it "routes to #show" do
      get("/shows/1").should route_to("shows#show", :id => "1")
    end

    it "routes to #edit" do
      get("/shows/1/edit").should route_to("shows#edit", :id => "1")
    end

    it "routes to #create" do
      post("/shows").should route_to("shows#create")
    end

    it "routes to #update" do
      put("/shows/1").should route_to("shows#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/shows/1").should route_to("shows#destroy", :id => "1")
    end

  end
end
