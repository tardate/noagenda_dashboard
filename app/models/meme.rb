class Meme < ActiveRecord::Base
  has_many :notes
  has_many :shows, :through => :notes

  scope :select_listing, order(:name)

end
