module ApplicationHelper
  
  # Returns media player code given audio url
  def embed_media_player(source_url,autoplay=false)
    return unless source_url.present?
    if browser.ios?
      # setting autoplay, although it doesn't actually work on iPad ""
      # TODO: re-organise the playback so that can play via javascript
      autoplay_param = autoplay ? 'autoplay' : ''
      return raw <<-EOSCRIPT
<div id="showstream" class="mediaplayer html5"><audio src="#{source_url}" controls #{autoplay_param}></audio></div>
      EOSCRIPT
    else
      autoplay_param = autoplay ? '&autoPlay=true' : ''
      return raw <<-EOSCRIPT
<div class="mediaplayer flash"><embed type="application/x-shockwave-flash" wmode="transparent"
src="http://www.google.com/reader/ui/3523697345-audio-player.swf?audioUrl=#{source_url}#{autoplay_param}"></embed></div>
      EOSCRIPT
    end
  end

  # Returns the set of links to use in the book of knowledge
  def bok_links
    [
      { :url => 'http://www.noagendashow.com/', :name => 'NoAgendaShow.com'},
      { :url => 'http://noagendachat.net/', :name => 'NoAgenda Chat'},
      { :url => 'http://www.noagendasoundboard.com/', :name => 'NoAgenda Soundboard'},
      { :url => 'http://noagendastream.com/', :name => 'NoAgenda Stream'},
      { :url => 'http://en.wikipedia.org/wiki/No_Agenda', :name => 'wikipedia'}
    ]
  end

  # Returns the set of links to use in the donation menu
  def dedouche_links
    [
      { :url => 'http://dvorak.org/na', :name => 'Blankets'},
      { :url => 'http://dvorak.org/na', :name => 'Water'},
      { :url => 'http://dvorak.org/na', :name => 'Just Send Cash'}
    ]
  end

  # Returns the show record for the current context
  # If under a show controller - returns the show
  # Else returns latest show
  def current_show_context
    show = if defined?(parent?).present? && parent? && parent.is_a?(Show)
      parent
    elsif defined?(resource).present? && resource.is_a?(Show)
      resource
    else
      Show.latest
    end
    return show
  rescue
    Show.latest
  end

  def insert_ga_script(ga_id)
    return unless ga_id
    return raw <<-EOGA
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '#{ga_id}']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
    EOGA
  end
end
