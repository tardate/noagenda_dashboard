require "spec_helper"

describe NotesController do
  describe "routing" do

    it "routes to #index" do
      get("/notes").should route_to("notes#index")
    end

    it "routes to #show" do
      get("/notes/1").should route_to("notes#show", :id => "1")
    end

  end
end
