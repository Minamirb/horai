require 'spec_helper'

describe PostsController do
  before do
    @user = Factory(:user)
    sign_in @user
    @post = @user.posts.create!(valid_attributes)
  end

  def valid_attributes
    {:comment => "comment", :photo => File.new(Rails.root.join("spec", "files", "with_geo.jpg"))}
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      get :show, :user_id => @user.nickname, :id => @post.id.to_s
      assigns(:post).should eq(@post)
    end
  end

  describe "GET index" do
    it "assigns the requestd users posts at @posts" do
      get :index, :user_id => @user.nickname
      posts = assigns(:posts).map(&:user_id).uniq
      posts.length.should == 1
      User.find(posts.first).nickname.should == @user.nickname
    end
  end

  describe "logged in" do
    before do
      sign_in(@user)
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Post" do
          expect {
            post :create, :post => valid_attributes
          }.to change(Post, :count).by(1)
        end

        it "assigns a newly created post as @post" do
          post :create, :post => valid_attributes
          assigns(:post).should be_a(Post)
          assigns(:post).should be_persisted
        end

        it "redirects to the created post" do
          post :create, :post => valid_attributes
          response.should redirect_to(Post.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved post as @post" do
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          post :create, :post => {}
          assigns(:post).should be_a_new(Post)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Post.any_instance.stub(:save).and_return(false)
          post :create, :post => {}
          response.should render_template("root/index")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested post" do
        expect {
          delete :destroy, :id => @post.id.to_s
        }.to change(Post, :count).by(-1)
      end

      it "redirects to the posts list" do
        delete :destroy, :id => @post.id.to_s
        response.should redirect_to(root_url)
      end
    end
  end
end
