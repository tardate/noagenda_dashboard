module ::Navd::Scraper
  class ShowLoader
    attr_accessor :number, :spider, :uri, :found, :published, :errors
    attr_reader :url, :published_date, :audio_url, :cover_art_url, :assets_url, :show_notes_url, :credits
      
    def initialize(number)
      self.errors = []
      self.number = number
      self.spider = Navd::Scraper::Spider.new
    end

    def loaded?
      found && errors.empty?
    end

    def scan_show_assets
      unless self.uri = spider.get_uri_for_show(number)
        self.errors << "URI could not be found for show number #{number}"
        return
      end
      unless page = spider.get_page(uri)
        self.errors + spider.errors
        return
      end
      self.found = true
    end
    
  end
end