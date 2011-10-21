class Show < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :memes, :through => :notes, :uniq => true, :order => :name

  scope :select_listing, where(:published => true).order('number desc')

  scope :meme_stats, lambda { |show_id=nil|
    query = show_id ? unscoped.where(Show.arel_table[:id].eq(show_id)) : unscoped
    query.
    select("memes.name AS meme_name, count(notes.id) as note_count").
    joins(:memes).
    group(:"memes.name").
    order('count(notes.id)')
  }

  class << self
    def latest
      order('number desc').limit(1).first
    end
    def next_number_to_load
      (Show.maximum(:number) || AppConstants.earliest_show_to_load - 1) + 1
    end
  end

  STAT_CHART_TEMPLATE = {
    xlabels: { :column => 'meme_name'},
    yvalues: { :column => 'note_count'}
  }.freeze

  def full_title
    "#{number} - #{published_date.to_s}"
  end

  def to_param
    "#{number}"
  end

  def meme_stat
    self.class.meme_stats(self.id)
  end
end
