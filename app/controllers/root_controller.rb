# -*- coding: utf-8 -*-
class RootController < ApplicationController
  def index
    @posts = Post.order_by(:created_at.desc).page(params[:page]).per(20)
  end
end
