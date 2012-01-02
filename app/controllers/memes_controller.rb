class MemesController < InheritedResources::Base
  belongs_to :show, :finder => :find_by_number!, :optional => true
  custom_actions :collection => [:stats,:top], :member => [:stat]
  respond_to :html, :json, :xml

  include Navd::Chartable
  
  def stats
    over_all_time = !(params[:over_all_time] && params[:over_all_time] =~ /^f/i)
    render :json => to_chartable_structure(Meme.stats_over_time(nil,over_all_time),Meme::STAT_CHART_TEMPLATE).to_json
  end

  def stat
    render :json => to_chartable_structure(resource.stat_over_time,Meme::STAT_CHART_TEMPLATE).to_json
  end

  def top
    @memes = Meme.topn
    top!
  end
end
