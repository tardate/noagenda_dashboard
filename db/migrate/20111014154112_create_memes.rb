class CreateMemes < ActiveRecord::Migration
  def self.up
    create_table :memes do |t|
      t.string     :name
      t.timestamps
    end
    change_table :memes do |t|
      t.index [:name], :unique => true
    end
  end

  def self.down
    drop_table :memes
  end
end
