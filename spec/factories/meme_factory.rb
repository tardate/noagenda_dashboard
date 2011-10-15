Factory.define :meme do |f|
  f.sequence(:name) { |n| "meme_#{n}" }
end
