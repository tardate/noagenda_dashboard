class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.integer    :number
      t.date       :published_date
      t.boolean    :published
      t.string     :url
      t.string     :audio_url
      t.string     :cover_art_url
      t.string     :assets_url
      t.string     :show_notes_url
      t.text       :credits
      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
