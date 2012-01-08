class Note < ActiveRecord::Base
  belongs_to :show
  belongs_to :meme

  scope :show_meme_note_order, includes(:show).includes(:meme).reorder('shows.number desc, memes.name asc, notes.name asc')
  scope :videos, includes(:show).includes(:meme).where(:'memes.name' => 'VIDEO')
end
