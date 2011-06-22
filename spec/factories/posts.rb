Factory.define :post do |f|
  f.comment "Comment"
  f.photo File.new(Rails.root.join("spec", "files", "with_geo.jpg"))
end
