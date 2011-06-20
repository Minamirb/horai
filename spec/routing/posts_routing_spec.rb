require "spec_helper"

describe PostsController do
  describe "routing" do
    it "routes to #show" do
      get("/posts/1").should route_to("posts#show", :id => "1")
    end

    it "routes to #create" do
      post("/posts").should route_to("posts#create")
    end

    it "routes to #destroy" do
      delete("/posts/1").should route_to("posts#destroy", :id => "1")
    end

  end
end
