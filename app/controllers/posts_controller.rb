class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @posts = context_user.posts
  end

  def show
    @post = Post.find(params[:id])
    respond_with(@post)
  end

  def create
    @post = current_user.posts.new(params[:post])
    success = @post.save
    respond_with(@post) do |f|
      unless success
        f.html{ render "root/index" }
      end
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    success = @post.update_attributes(params[:post])
    respond_with(@post)
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  private
  def context_user
    User.first(:conditions => {:nickname => params[:user_id]})
  end
end
