class CreateMemes < ActiveRecord::Migration
  def self.up
    create_table :memes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :memes
  end
end
