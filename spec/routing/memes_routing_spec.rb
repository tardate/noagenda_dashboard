require "spec_helper"

describe MemesController do
  describe "routing" do

    it "routes to #index" do
      get("/memes").should route_to("memes#index")
    end

    it "routes to #show" do
      get("/memes/1").should route_to("memes#show", :id => "1")
    end

  end
end
