class VideosController < InheritedResources::Base
  defaults :resource_class => Note
  belongs_to :show, :finder => :find_by_number!, :optional => true
  respond_to :rss

  protected
    def begin_of_association_chain
      resource_class.videos unless parent?
    end
    def collection
      @videos ||= end_of_association_chain.show_meme_note_order
    end
end
