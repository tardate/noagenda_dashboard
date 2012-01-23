
desc "Start irb with libs pre-loaded"
task :console do
  exec "irb -r ./spec/spec_helper"
end
task :c => :console