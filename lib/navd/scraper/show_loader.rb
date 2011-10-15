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
      self.uri, page = spider.get_page_for_show(number)
      if spider.errors.present?
        self.errors + spider.errors
        return
      end
      self.found = true
    end
    
  end
end