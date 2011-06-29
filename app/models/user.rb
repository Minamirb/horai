class User
  include Mongoid::Document
  attr_accessible :provider, :uid, :name, :nickname
  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String
  field :nickname, :type => String

  def self.create_with_omniauth(auth) 
    begin
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        
        if auth['user_info']
          # Twitter, Google, Yahoo, GitHub
          user.name = auth['user_info']['name'] if auth['user_info']['name']
          user.nickname = auth['user_info']['nickname'] if auth['user_info']['nickname']
          # Google, Yahoo, GitHub
          user.email = auth['user_info']['email'] if auth['user_info']['email']
        end

        if auth['extra']['user_hash']
          # Facebook
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
          # Facebook
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email']
        end

      end
    rescue Exception
      raise Exception, "cannot create user record"
    end
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def new
    redirect_to '/auth/twitter'
  end
end
