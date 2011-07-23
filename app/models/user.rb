class User
  include Mongoid::Document
  attr_accessible :provider, :uid, :name, :nickname
  field :provider,  :type => String
  field :uid,       :type => String
  field :token,     :type => String
  field :secret,    :type => String
  field :name,      :type => String
  field :avatar,    :type => String
  field :nickname,  :type => String
  field :introduce, :type => String
  has_many :posts

  def self.omniauth(auth)
    if user = User.where(:provider => auth['provider'], :uid => auth['uid']).first
      return user
    end

    create! do |user|
      user.provider = auth['provider']
      user.uid      = auth['uid']
    end
  end
end
