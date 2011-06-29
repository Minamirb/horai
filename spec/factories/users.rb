# -*- coding: utf-8 -*-
Factory.define :user do |f|
  f.provider "twitter"
  f.uid Digest::MD5.hexdigest(Time.now.to_f.to_s)
  f.name "よしだあつし"
  f.nickname 'yalab'
end
