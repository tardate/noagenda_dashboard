class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string     :name
      t.text       :description
      t.string     :url, :limit => 2000
      t.belongs_to :show
      t.references :meme
      t.timestamps
    end
    change_table :notes do |t|
      t.index [:show_id]
      t.index [:meme_id]
      t.index [:meme_id,:show_id]
      t.index [:show_id,:url]
    end
  end

  def self.down
    drop_table :notes
  end
end
