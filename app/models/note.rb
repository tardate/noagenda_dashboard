class Note < ActiveRecord::Base
  belongs_to :show
  belongs_to :meme
end
