class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    respond_with(@post)
  end

  def create
    @post = Post.new(params[:post])
    success = @post.save
    respond_with(@post) do |f|
      unless success
        f.html{ render "root/index" }
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    success = @post.update_attributes(params[:post])
    respond_with(@post)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
end
