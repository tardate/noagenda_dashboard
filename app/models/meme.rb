# coding: utf-8
class Meme < ActiveRecord::Base
  has_many :notes
  has_many :shows, :through => :notes

  scope :select_listing, order(:name)

  class << self
    # Tries to coalesce different spellings to one standard form
    def normalize_name(value)
      case value
      when /bi.+vers/i
        'Biodiversitée'
      when /eq.+chine/i
        'EQ Machine$'
      when /fal[s\$]e flag/
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
