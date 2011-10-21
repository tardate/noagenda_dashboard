Factory.define :meme do |f|
  f.sequence(:name) { |n| "meme_#{n}" }
  f.trending true
end
