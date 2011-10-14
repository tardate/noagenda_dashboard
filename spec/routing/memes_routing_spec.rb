require "spec_helper"

describe MemesController do
  describe "routing" do

    it "routes to #index" do
      get("/memes").should route_to("memes#index")
    end

    it "routes to #new" do
      get("/memes/new").should route_to("memes#new")
    end

    it "routes to #show" do
      get("/memes/1").should route_to("memes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/memes/1/edit").should route_to("memes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/memes").should route_to("memes#create")
    end

    it "routes to #update" do
      put("/memes/1").should route_to("memes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/memes/1").should route_to("memes#destroy", :id => "1")
    end

  end
end
