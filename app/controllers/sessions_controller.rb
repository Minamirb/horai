class SessionsController < ApplicationController
  def new
    redirect_to '/auth/twitter'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.omniauth(auth)
     {auth['user_info']   => ['name', 'nickname', 'image', 'description'],
      auth['credentials'] => ['token', 'secret']}.each do |hash, keys|
      p hash
      keys.each{|k| user.write_attribute(k, hash[k])  }
    end
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end
end
