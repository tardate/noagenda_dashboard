# coding: utf-8
class Meme < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  has_many :shows, :through => :notes, :uniq => true, :order => 'number desc'

  scope :select_listing, order(:name)

  scope :top10, lambda {
    unscoped.where(Meme.arel_table[:id].in(top10_arel))
  }

  scope :stats_over_time, lambda {
    unscoped.
    select("memes.name AS meme_name, shows.number as number, count(notes.id) as note_count").
    joins(:shows).
    where(Meme.arel_table[:id].in(top10_arel)).
    group(:"memes.name", :"shows.number").
    order('memes.name, shows.number')
  }

  class << self
    # Returns the arel fragment to get the mem ids of the top 10 memes over time
    # TODO: VIDEO gets included, maybe it shouldn't
    def top10_arel
      n = Note.arel_table
      n.project(n[:meme_id]).group(n[:meme_id]).order('count(id) desc').take(10)
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
