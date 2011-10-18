class MemesController < InheritedResources::Base
  belongs_to :show, :finder => :find_by_number!, :optional => true

  def show
    if request.xhr?
      render :partial => 'memes/show'
    else
      show!
    end
  end

end
