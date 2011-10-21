class ShowsController < InheritedResources::Base
  defaults :finder => :find_by_number!
  custom_actions :member => [:stat]
  respond_to :html, :json, :xml

  include Navd::Chartable

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

  def stat
    render :json => to_chartable_structure(resource.meme_stat,Show::STAT_CHART_TEMPLATE).to_json
  end
end
