class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Mongoid::Geo::Near
  field :comment, :type => String
  field :photo,   :type => String
  field :location, :type => Array, :geo => true
  index [[:location, Mongo::GEO2D], [:created_at, Mongo::ASCENDING]], :min => -180, :max => 180
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  before_save :extract_geo_location

  private
  def extract_geo_location
    tags = EXIFR::JPEG.new(photo.path)
    latlng = [:latitude, :longitude].map{|tag|
      (h, m, s) = tags.exif[:"gps_#{tag}"]
      (h + m / 60 + s / 3600).to_f
    }
    self.location = latlng
  end
end
