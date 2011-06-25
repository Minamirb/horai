# -*- coding: utf-8 -*-
class RootController < ApplicationController
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
