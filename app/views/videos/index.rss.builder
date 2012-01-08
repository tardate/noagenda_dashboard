xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    if parent?
      xml.title "NoAgenda Videos for Show ##{parent.number}"
      xml.link parent_url
    else
      xml.title "NoAgenda Videos"
      xml.link root_url
    end
    xml.description "this is a feed of all videos linked in the show notes"

    for note in collection
      xml.item do
        xml.title h( note.name )
        xml.description h( note.description )
        xml.category note.show.short_id
        xml.pubDate note.show.published_date.rfc822
        xml.link note.url
      end
    end
  end
end
