# -*- coding: utf-8 -*-
require 'spec_helper'

describe Post do
  it { should have_fields(:comment, :photo, :created_at, :updated_at, :location) }
  it { should belong_to(:user) }

  describe "画像をアップロードした時" do
    before do
      @post = Post.new
    end
    it "exif に位置情報があれば取り出す" do
      @post.photo = File.new(Rails.root.join('spec', 'files', 'with_geo.jpg'))
      @post.save
      @post.location.should eq [34.655176194444444, 135.5002445]
    end

    it "exif に位置情報が無くてもエラーにはならない" do
      @post.photo = File.new(Rails.root.join('spec', 'files', 'without_geo.jpg'))
      expect { @post.save }.to_not raise_error
    end

    it "exif が無くてもエラーにはならない" do
      @post.photo = File.new(Rails.root.join('spec', 'files', 'without_exif.jpg'))
      expect { @post.save }.to_not raise_error
    end
  end
end
