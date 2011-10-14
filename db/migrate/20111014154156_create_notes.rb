class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :name
      t.text :description
      t.string :url
      t.belongs_to :show
      t.references :meme
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
