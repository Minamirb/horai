require 'spec_helper'

describe RootController do
  describe "GET 'index'" do
    before do
      22.times do
        Factory(:post)
      end
    end
    it "should be successful" do
      get 'index'
      response.should be_success
      assigns(:posts).should_not be_nil
      assigns(:posts).length.should eq 20
    end
    describe "as xhr" do
      before do
        xhr :get, 'index', :page => "2"
      end
      it "is success"  do
        response.should be_success
      end
      it "render posts/index" do
        response.should render_template("root/_comments")
      end
    end
  end
end
