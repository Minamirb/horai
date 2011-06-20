class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :comment, :type => String
  field :photo,   :type => String
  belongs_to :user
end
