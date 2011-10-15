class Show < ActiveRecord::Base
  has_many :notes
  has_many :memes, :through => :notes

  class << self
    def latest
      order('published_date desc').limit(1).first
    end
  end
end
