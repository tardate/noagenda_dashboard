Factory.define :show do |f|
  f.sequence(:number)
  f.sequence(:name) { |n| "show_#{n}" }
  f.published_date Date.today
end
