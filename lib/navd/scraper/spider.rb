module ::Navd::Scraper
  class Spider
    include Navd::Scraper::Support
    attr_accessor :errors

    def initialize
      self.errors = []
    end

    # Returns the url for the specific show
    def get_uri_for_show(show_number)
      # TODO: prior to 301, this didn't work - need alternative method'
      url = "http://#{show_number}.nashownotes.com/"
      normalize_uri(url)
    rescue Exception => e
      self.errors << e
      nil
    end

    # Loads HTML web page
    # Returns Nokogiri::HTML::Document or nil (if error)
    def get_page(uri)
      Nokogiri::HTML(open(uri,"UserAgent" => "Mozilla/5.0"))
    rescue Exception => e
      self.errors << e
      nil
    end

    # Loads HTML web page for specific show number
    # Returns [URI,Nokogiri::HTML::Document] or nil (if error)
    def get_page_for_show(number)
      uri = get_uri_for_show(number)
      doc = uri && get_page(uri)
      [uri,doc]
    end

  end
end