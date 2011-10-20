require 'ostruct'
AppConstants = OpenStruct.new(YAML::load(File.open(Rails.root.join('config','constants.yml')))[Rails.env])