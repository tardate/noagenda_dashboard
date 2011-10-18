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
        show_loader.show_notes.each do |show_note|
          meme = Meme.factory(show_note[:meme_name])
          note = Note.find_or_initialize_by_show_id_and_url(show.id,show_note[:url])
          note.update_attributes!(
            :name => show_note[:name],
            :meme_id => meme.try(:id),
            :description => show_note[:description]
          )
        end
      end
    end

  end
end