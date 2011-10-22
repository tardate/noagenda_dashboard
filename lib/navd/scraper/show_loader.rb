module ::Navd::Scraper
  class ShowLoader
    attr_accessor :number, :spider, :uri, :found, :published, :errors
    attr_reader :attributes, :show_notes

    # +number+ - show number to load
    def initialize(number)
      @errors = []
      @number = number
      @spider = Navd::Scraper::Spider.new
      @attributes = {}
      @show_notes = []
    end

    # Returns true if show details have been scraped without error
    def loaded?
      found && errors.empty?
    end

    # Loads all the show details for given show
    # If an error is encountered, +@errors+ will be present
    def scan_show_assets
      @uri, page = spider.get_page_for_show(number)
      if spider.errors.present?
        @errors += spider.errors
        return
      end
      @found = true
      @attributes[:number] = number
      @attributes[:show_notes_url] = uri.to_s
      unless @attributes[:audio_url] = extract_mp3_link(page)
        @errors << 'show is not yet published'
        @published = false
        return
      end
      @attributes[:published] = @published = true
      @attributes[:published_date] = extract_show_date(@attributes[:audio_url])
      @attributes[:cover_art_url] = extract_cover_art_link(page)
      @attributes[:assets_url] = uri.merge(extract_assets_link(page)).to_s
      @attributes[:url] = extract_episode_web_link(page)
      show_note_details_uri = uri.merge(extract_show_notes_link(page))
      # TODO: credits
      @show_notes = extract_show_notes(show_note_details_uri)
    end

    # Returns an array of hashes with show note detail (:name,:meme_name,:description,:url)
    # +show_note_details_uri+ URI to show note details page (e.g. http://349.nashownotes.com/shownotes)
    def extract_show_notes(show_note_details_uri)
      all_notes = get_all_notes_page(show_note_details_uri)
      extract_notes_from_page(all_notes)
    end

    # TODO: need some refactoring and exception handling
    # +show_note_details_uri+ URI to show note details page (e.g. http://349.nashownotes.com/shownotes)
    def get_all_notes_page(show_note_details_uri)
      assets_page = spider.get_page(show_note_details_uri)
      notes_uri = show_note_assets_uri.merge(extract_show_notes_link(assets_page))
      notes_page = spider.get_page(notes_uri)
      all_notes_uri = show_note_assets_uri.merge(extract_nodes(notes_page,:all_notes)[:href])
      spider.get_page(all_notes_uri)
    end

    def extract_notes_from_page(page)
      notes = []
      current_meme = nil
      page.at_css('ul.ulDirectory').children.each do |n|
        if n.name=='li' && n[:class]=='directoryItem'
          current_meme = n.text
        elsif n.name=='ul' && n[:class]=='ulDirectory'
          current_title = nil
          n.children.each do |meme|
            if meme.name=='li' && meme[:class]=='directoryItem'
              current_title = meme.text
            elsif meme.name=='ul' && meme[:class]=='ulDirectory'
              anchor = meme.at_css('a') || {}
              notes << {
                :name => current_title,
                :meme_name => current_meme,
                :description => meme.text,
                :url => anchor[:href]
              }
            end
          end
        end
      end
      notes
    end

    # Returns the show date (as extracted from the audio file name)
    # Dodgy approach, but seems the most reliable way of automatically getting the show date
    def extract_show_date(mp3)
      # cheat, we get from the audio file name
      mdy=mp3.match( /noagenda-\d*-(\d+)-(\d+)-(\d+)/ )
      Date.parse("#{mdy[3]}-#{mdy[1]}-#{mdy[2]}")
    rescue Exception => e
      @errors << e
      nil
    end

    # Returns the link to audio file
    # +page+ is the Nokogiri::HTML::Document main shownotes page
    # e.g. http://m.podshow.com/media/15412/episodes/299798/noagenda-299798-10-20-2011.mp3
    def extract_mp3_link(page)
      extract_nodes(page,:mp3)[:href]
    end
    # Returns the link to cover art
    # +page+ is the Nokogiri::HTML::Document main shownotes page
    # e.g. http://dropbox.curry.com/ShowNotesArchive/2011/10/NA-349-2011-10-20/Assets/ns349art.png
    def extract_cover_art_link(page)
      extract_nodes(page,:cover_art)[:href]
    end
    # Returns the link to show assets page
    # +page+ is the Nokogiri::HTML::Document main shownotes page
    # e.g. http://349.nashownotes.com/assets
    def extract_assets_link(page)
      extract_nodes(page,:assets)[:href]
    end
    # Returns the link to show notes assets page
    # +page+ is the Nokogiri::HTML::Document main shownotes page
    # e.g. http://349.nashownotes.com/shownotes
    def extract_show_notes_link(page)
      extract_nodes(page,:notes)[:href]
    end
    # Returns the link to official show page
    # +page+ is the Nokogiri::HTML::Document main shownotes page
    # e.g. http://blog.curry.com/stories/2011/10/20/na34920111020.html
    def extract_episode_web_link(page)
      extract_nodes(page,:web)[:href]
    end

    # Set of algorithms to extracts parts of a page
    # +page+ is a Nokogiri::HTML::Document
    # +item+ - symbol for note type required
    def extract_nodes(page,item)
      result = case item
      when :all_notes
        page.css('a.directoryLink').select{|n| n.text[/expand all/i] }.first
      when :assets
        page.css('a.directoryLink').select{|n| n.text[/Assets/] }.first
      when :cover_art
        page.css('.directoryComment > a').select{|n| n.text[/Art/] }.first
      when :mp3
        page.css('.directoryComment > a').select{|n| n.text[/mp3/] }.first
      when :notes
        page.css('a.directoryLink').select{|n| n.text[/notes/] }.first
      when :web
        page.css('.directoryComment a').select{|n| n.text[/Episode/] }.first
      end
      result || {}
    end
  end
end