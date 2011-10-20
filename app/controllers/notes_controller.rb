class NotesController < InheritedResources::Base
  respond_to :html, :json, :xml

  belongs_to :show, :finder => :find_by_number!, :optional => true  do
    belongs_to :meme, :optional => true
  end
end
