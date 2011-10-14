class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.integer :code
      t.date :published

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
