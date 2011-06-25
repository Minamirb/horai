class User
  include Mongoid::Document
  attr_accessible :provider, :uid, :name
  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String
end
