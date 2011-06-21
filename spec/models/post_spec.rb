# -*- coding: utf-8 -*-
require 'spec_helper'

describe Post do
  it { should have_fields(:comment, :photo, :created_at, :updated_at, :location) }
  it { should belong_to(:user) }

  describe "画像をアップロードした時" do
    it "exif に位置情報があれば取り出す" do
      post = Post.new
      post.photo = File.new(Rails.root.join('spec', 'files', 'with_geo.jpg'))
      post.save
      assert_equal [34.655176194444444, 135.5002445], post.location
    end
  end
end
