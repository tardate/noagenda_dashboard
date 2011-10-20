class MemesController < InheritedResources::Base
  belongs_to :show, :finder => :find_by_number!, :optional => true
  custom_actions :collection => [:stats], :member => [:stat]

  include Navd::Chartable

  def show
    if request.xhr?
      render :partial => 'memes/show'
    else
      show!
    end
  end

  def stats
    render :json => to_chartable_structure(Meme.stats_over_time,Meme::STAT_CHART_TEMPLATE).to_json
  end

  def stat
    render :json => to_chartable_structure(resource.stat_over_time,Meme::STAT_CHART_TEMPLATE).to_json
  end

end
