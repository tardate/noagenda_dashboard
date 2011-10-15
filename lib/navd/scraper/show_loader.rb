module ::Navd::Scraper
  class ShowLoader
    attr_accessor :number, :spider, :uri, :found, :published, :errors
    attr_reader :attributes
    
    def initialize(number)
      @errors = []
      @number = number
      @spider = Navd::Scraper::Spider.new
      @attributes = {}
    end

    def loaded?
      found && errors.empty?
    end

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
        @published = false
        return
      end
      @attributes[:published] = @published = true
      @attributes[:published_date] = extract_show_date(@attributes[:audio_url])
      @attributes[:cover_art_url] = extract_cover_art_link(page)
      @attributes[:assets_url] = URI.join(@attributes[:show_notes_url],extract_assets_link(page)).to_s
      @attributes[:url] = extract_episode_web_link(page)
      show_note_assets_url = URI.join(@attributes[:show_notes_url],extract_show_notes_link(page)).to_s
      # credits
      # show notes
    end

    def extract_show_date(mp3)
      # cheat, we get from the audio file name
      mdy=mp3.match( /noagenda-\d*-(\d+)-(\d+)-(\d+)/ )
      Date.parse("#{mdy[3]}-#{mdy[1]}-#{mdy[2]}")
    rescue Exception => e
      @errors << e
      nil
    end

    def extract_mp3_link(page)
      extract_nodes(page,:mp3)[:href]
    end
    def extract_cover_art_link(page)
      extract_nodes(page,:cover_art)[:href]
    end
    def extract_assets_link(page)
      extract_nodes(page,:assets)[:href]
    end
    def extract_show_notes_link(page)
      extract_nodes(page,:notes)[:href]
    end
    def extract_episode_web_link(page)
      extract_nodes(page,:web)[:href]
    end

    def extract_nodes(page,item)
      result = case item
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