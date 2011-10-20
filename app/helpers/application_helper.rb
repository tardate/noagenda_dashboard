module ApplicationHelper
  
  # Returns media player code given audio url
  def embed_media_player(source_url)
    return unless source_url.present?
    if browser.ios?
      return raw <<-EOSCRIPT
<div class="mediaplayer html5"><embed src="#{source_url}" autoplay="false"></embed></div>
      EOSCRIPT
    else
      return raw <<-EOSCRIPT
<div class="mediaplayer flash"><embed type="application/x-shockwave-flash" wmode="transparent"
src="http://www.google.com/reader/ui/3523697345-audio-player.swf?audioUrl=#{source_url}"></embed></div>
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
end
