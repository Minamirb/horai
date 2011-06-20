class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :default_output
  respond_to :html, :json
  private
  def default_output
    @post = Post.new(params[:post])
  end
end
