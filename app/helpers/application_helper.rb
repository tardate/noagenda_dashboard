module ApplicationHelper
  
  def embed_media_player(source_url,h=27,w=320)
    return unless source_url.present?
    return raw <<-EOSCRIPT
<div class="player"><embed type="application/x-shockwave-flash" wmode="transparent" height="#{h}" width="#{w}"
src="http://www.google.com/reader/ui/3523697345-audio-player.swf?audioUrl=#{source_url}"></embed></div>
    EOSCRIPT
  end
end
