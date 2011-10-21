class ShowsController < InheritedResources::Base
  defaults :finder => :find_by_number!
  respond_to :html, :json, :xml

  def show
    if request.xhr?
      render :partial => 'shows/show'
    else
      show!
    end
  end

  def mediawidget
    render :partial => 'shows/mediawidget', :locals => { :autoplay => params[:autoplay] && params[:autoplay]=='true' }
  end
end
