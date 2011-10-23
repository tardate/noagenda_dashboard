class NotesController < InheritedResources::Base
  respond_to :html, :json, :xml

  belongs_to :show, :finder => :find_by_number!, :optional => true  do
    belongs_to :meme, :optional => true
  end

  protected

    def collection
      search_params = params[:search]
      @notes ||= if search_params.present?
        end_of_association_chain.search(search_params)
      else
        end_of_association_chain.scoped
      end
    end

end
