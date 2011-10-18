class Show < ActiveRecord::Base
  has_many :notes
  has_many :memes, :through => :notes, :uniq => true, :order => :name

  scope :select_listing, where(:published => true).order('number desc')

  class << self
    def latest
      order('number desc').limit(1).first
    end
  end

  def full_title
    "#{number} - #{published_date.to_s}"
  end

  def to_param
    "#{number}"
  end

end
