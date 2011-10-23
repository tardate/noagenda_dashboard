class Note < ActiveRecord::Base
  belongs_to :show
  belongs_to :meme

  default_scope order('notes.name')
  scope :show_meme_note_order, includes(:show).includes(:meme).reorder('shows.number desc, memes.name asc, notes.name asc')

end
