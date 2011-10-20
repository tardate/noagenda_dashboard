class MemesController < InheritedResources::Base
  belongs_to :show, :finder => :find_by_number!, :optional => true
  custom_actions :collection => [:stats]

  include Navd::Chartable

  def show
    if request.xhr?
      render :partial => 'memes/show'
    else
      show!
    end
  end

  def stats
    template_options = {
      template: 'line_basic',
      ylabels: { :column => 'meme_name'},
      yvalues: { :column => 'note_count'},
      xlabels: { :column => 'number'}
    }
    render :json => to_chartable_structure(Meme.stats_over_time,template_options).to_json
  end
end
