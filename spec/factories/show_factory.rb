Factory.define :show do |f|
  f.sequence(:number)
  f.sequence(:name) { |n| "show_#{n}" }
end
