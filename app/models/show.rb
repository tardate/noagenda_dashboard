class Show < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  delegate :videos, :to => :notes
  has_many :memes, :through => :notes, :uniq => true, :order => :name

  default_scope order('shows.number desc')
  scope :select_listing, where(:published => true)

  # TODO: there's a better query construct possible than this=>
  scope :meme_stats, lambda { |show_id=nil|
    n = Note.arel_table
    query = show_id ? unscoped.where(Show.arel_table[:id].eq(show_id)) : unscoped
    query.
    select("memes.name AS meme_name, count(notes.id) as note_count").
    joins(:memes).
    where(n[:meme_id].not_in(Meme.non_trending_arel)).
    group(:"memes.name").
    reorder('count(notes.id)')
  }

  class << self
    def latest
      order('number desc').limit(1).first
    end
    def next_number_to_load
      (Show.maximum(:number) || AppConstants.earliest_show_to_load - 1) + 1
    end
    # Returns the arel fragment to get the show ids for the last +limit+ shows
    # Trending is based on lastn_shows
    def lastn_arel(limit = AppConstants.number_of_shows_for_trending)
      s = Show.arel_table
      s.project(s[:id]).
      order(s[:number].desc).take(limit)
    end
    # Returns the arel fragment to get the show ids for the number_of_shows_for_trending_history
    def shows_for_trending_history_arel
      lastn_arel(AppConstants.number_of_shows_for_trending_history || 10)
    end
  end

  STAT_CHART_TEMPLATE = {
    xlabels: { :column => 'meme_name'},
    yvalues: { :column => 'note_count'}
  }.freeze

  def short_title
    "#{number} - #{published_date.to_s}"
  end

  def short_id
    "NA#{number}"
  end

  def full_title
    "#{number} - #{published_date.to_s} #{name}"
  end

  def to_param
    "#{number}"
  end

  def meme_stat
    self.class.meme_stats(self.id)
  end

  # Returns an announcement message formated for posting to twitter
  def twitter_publish_message
    "#NoAgenda show ##{number} attack vectors now at http://noagendadashboard.com"
  end
end
