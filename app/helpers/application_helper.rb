module ApplicationHelper
  
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

end
