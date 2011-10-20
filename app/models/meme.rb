# coding: utf-8
class Meme < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :shows, :through => :notes, :uniq => true, :order => 'number desc'

  scope :select_listing, order(:name)

  scope :topn, lambda { |limit=10|
    unscoped.where(Meme.arel_table[:id].in(topn_arel(limit)))
  }

  scope :stats_over_time, lambda { |meme_id=nil|
    unscoped.
    select("memes.name AS meme_name, shows.number as number, count(notes.id) as note_count").
    joins(:shows).
    where(Meme.arel_table[:id].in((meme_id ? meme_id : topn_arel(AppConstants.number_of_trending_memes)))).
    group(:"memes.name", :"shows.number").
    order('memes.name, shows.number')
  }

  # Gets the stats over time for the current meme
  def stat_over_time
    self.class.stats_over_time(self.id)
  end

  class << self
    # Returns the arel fragment to get the mem ids of the top 10 memes over time
    # TODO: VIDEO gets included, maybe it shouldn't
    def topn_arel(limit = 10)
      n = Note.arel_table
      n.project(n[:meme_id]).group(n[:meme_id]).order('count(id) desc').take(limit)
    end

    # Tries to coalesce different spellings to one standard form
    def normalize_name(value)
      case value
      when /bi.+vers/i
        'Biodiversitée'
      when /eq.+chine/i
        'EQ Machine$'
      when /fal[s\$]e.*flag/
        'Fal$e Flag'
      when /squirrel/i
        'Squirrel!!'
      when /trains.+planes/i
        'Trains Good, Planes Bad (Whoo Hoo!)'
      when /military.+industrial.+compl/i
        'Military Industrial Complex'
      else
        value
      end
    end

    # Returns the meme record for the given name
    # It will normalize the meme name as required
    # It will create the mem record if it doesn't already exist
    def factory(name)
      normalized_name = normalize_name(name)
      find_or_create_by_name(normalized_name)
    end
  end
end
