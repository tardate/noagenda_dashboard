class Meme < ActiveRecord::Base
  has_many :notes
  has_many :shows, :through => :notes
end
