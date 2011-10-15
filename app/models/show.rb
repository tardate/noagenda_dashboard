class Show < ActiveRecord::Base
  has_many :notes
  has_many :memes, :through => :notes
end
