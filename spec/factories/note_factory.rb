Factory.define :note do |f|
  f.sequence(:name) { |n| "name_#{n}" }
  f.sequence(:url) { |n| "http://localhost/url/#{n}" }
  f.sequence(:description) { |n| "description_#{n}" }
  f.association :show
  f.association :meme
end
