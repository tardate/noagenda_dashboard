# coding: utf-8
class Meme < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :shows, :through => :notes, :uniq => true, :order => 'number desc'

  default_scope order('memes.name')
  scope :select_listing, order(:name)

  scope :topn, lambda { |limit = AppConstants.number_of_trending_memes|
    unscoped.where(Meme.arel_table[:id].in(topn_arel(limit)))
  }

  scope :stats_over_time, lambda { |meme_id=nil|
    unscoped.
    select("memes.name AS meme_name, shows.number as number, count(notes.id) as note_count").
    joins(:shows).
    where(Meme.arel_table[:id].in((meme_id ? meme_id : topn_arel))).
    where(Show.arel_table[:id].in(Show.shows_for_trending_history_arel)).
    group(:"memes.name", :"shows.number").
    reorder('memes.name, shows.number')
  }

  # Gets the stats over time for the current meme
  def stat_over_time
    self.class.stats_over_time(self.id)
  end

  STAT_CHART_TEMPLATE = {
    ylabels: { :column => 'meme_name'},
    yvalues: { :column => 'note_count'},
    xlabels: { :column => 'number'}
  }.freeze

  class << self

    # Returns the arel fragment to get the meme ids of the top +limit+ memes over time
    # Trending is based on lastn_shows
    def topn_arel(limit = AppConstants.number_of_trending_memes)
      n = Note.arel_table
      n.project(n[:meme_id]).
      where(n[:show_id].in(Show.lastn_arel)).
      where(n[:meme_id].not_in(non_trending_arel)).
      group(n[:meme_id]).order('count(id) desc').take(limit)
    end

    # Returns the arel fragementto get the mem ids that are not trending
    def non_trending_arel
      m = Meme.arel_table
      m.project(m[:id]).
      where(m[:trending].eq(false))
    end

    # Merge +from_meme_name+ to +to_meme_name+
    def merge(from_meme_name,to_meme_name)
      to_meme = Meme.factory(to_meme_name)
      from_meme = Meme.find_by_name(from_meme_name)
      return unless to_meme && from_meme
      # move existing notes to the new meme
      from_meme.notes.update_all(:meme_id => to_meme.id)
      # remove the old meme
      from_meme.destroy
    end

    # Tries to coalesce different spellings to one standard form
    def normalize_name(value)
      case value
      when /2tth/i
        '2TTH'
      when /arab.+prin/i
        'Arab Spring'
      when /agen.+21/i
        'Agenda21'
      when /an.+constit/i
        'Anti Constitution'
      when /b.+versi/i
        'Biodiversitée'
      when /cyb.+war/i
        'CyberWar$'
      when /devil.+weed/i
        'Devil Weed & Powder'
      when /eq.+chine/i
        'EQ Machine$'
      when /fal[s\$]{1,2}e.*flag/i
        'Fal$e Flag'
      when /hiker/i
        'Hikers'
      when /hollywood.+whack|hollywood.+shoot/i
        'Hollywood Whacker$'
      when /l.b.*a/i
        'Libya'
      when /lone.+wolf/i
        'Lone Wolf'
      when /lucifer/i
        'Lucifer'
      when /magic.*number/i
        'Magic Numbers'
      when /military.+industrial.+compl/i
        'Military Industrial Complex'
      when /minist.*truth/i
        'Ministry of Truth'
      when /monsa.*t/i
        'Monsantooo'
      when /^pedo|pedo.*bear/i
        'PedoBear'
      when /ron.+paul/i
        'Ron Paul'
      when /science/i
        'The Science Is In!'
      when /hadow.*puppet.*thea/i
        'Shadow Puppet Theatre'
      when /shut.*up.*slave/i
        'Shut Up Slave!'
      when /squirrel/i
        'Squirrel!!'
      when /techno.*expert/i
        'Techno Experts'
      when /trains.+pla.es/i
        'Trains Good, Planes Bad (Whoo Hoo!)'
      when /united.*tate.*euro/i
        'United $tates of EUROpe'
      when /vaccin/i
        'Vaccine$'
      when /vagina/i
        'Vagina'
      when /we.+can.+wait/i
        "We Can't Wait!"
      when /word.+matter/i
        'Words Matter'
      when /zombie/i
        'Zombie Nation'
      when /clip|stuff/i
        'Clips'
      else
        value.length > 60 ? 'Other' : value
      end
    end

    # Returns the meme record for the given name
    # It will normalize the meme name as required
    # It will create the mem record if it doesn't already exist
    def factory(name)
      normalized_name = normalize_name(name)
      meme = find_or_create_by_name(normalized_name)
      if meme && name =~ /VIDEO|Clips/
        meme.update_attribute(:trending,false)
      end
      meme
    end
  end
end
