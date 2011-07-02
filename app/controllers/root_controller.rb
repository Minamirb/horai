# -*- coding: utf-8 -*-
class RootController < ApplicationController
  include Nyoibo::Callback
  uploaded "/" do |params, binary|
    post = Post.new
    post.comment = params['post[comment]']
    tempfile = Tempfile.new("RackMultipart")
    tempfile.binmode
    tempfile.write binary
    session = Horai::Application.config.session_store.new(Horai::Application).coder.decode(params['session_string'])
    post.photo =  ActionDispatch::Http::UploadedFile.new(:filename => params['filename'], :tempfile => tempfile, :type => 'image/jpg')
    post.user_id = session['user_id']
    post.save
  end

  def index
    @posts = Post.order_by(:created_at.desc).page(params[:page]).per(20)
    respond_with(@posts) do |f|
      f.html{
        if request.xhr?
          render "posts/index", :layout => false
        else
          render
        end
      }
    end
  end
end
