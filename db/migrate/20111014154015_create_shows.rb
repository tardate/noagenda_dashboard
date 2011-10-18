class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.integer    :number
      t.date       :published_date
      t.boolean    :published
      t.string     :url, :limit => 2000
      t.string     :audio_url, :limit => 2000
      t.string     :cover_art_url, :limit => 2000
      t.string     :assets_url, :limit => 2000
      t.string     :show_notes_url, :limit => 2000
      t.text       :credits
      t.timestamps
    end
    change_table :shows do |t|
      t.index [:number], :unique => true
      t.index [:published_date]
      t.index [:number,:published], :unique => true
    end
  end

  def self.down
    drop_table :shows
  end
end
