class NotesController < InheritedResources::Base
  belongs_to :show, :optional => true
end
