module ::Navd::Scraper
  class Control
    attr_accessor :options
  
    DEFAULT_OPTIONS = {}
  
    def initialize(custom_options={})
      self.options = DEFAULT_OPTIONS.merge(custom_options)
    end

    def load_show(number)
      show_loader = Navd::Scraper::ShowLoader.new(number)
      show_loader.scan_show_assets
      if show_loader.published
        show = Show.find_or_initialize_by_number(number)
        show.update_attributes!(show_loader.attributes)
      end
    end
  end
end