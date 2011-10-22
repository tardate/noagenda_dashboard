module ::Navd::Scraper
  class Control
    attr_accessor :options
  
    DEFAULT_OPTIONS = {}
  
    def initialize(custom_options={})
      self.options = DEFAULT_OPTIONS.merge(custom_options)
    end

    # Simple logger
    def log(msg, level=:info)
      m = "#{Time.now.utc}: #{msg}"
      puts m
      Rails.logger.send(level,m)
    end

    # Loads all shows, starting from last loaded, until it reaches an unpublished show number
    def load_all_shows
      begin
        loaded = load_show(Show.next_number_to_load)
      end while loaded
    end

    # +number+ - show number to load
    # TODO: support reload operations
    def load_show(number)
      log "#{number}: loading show"
      show_loader = Navd::Scraper::ShowLoader.new(number)
      show_loader.scan_show_assets
      if show_loader.errors.present?
        log "#{number}: errors: #{show_loader.errors.inspect}"
        return false
      end
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
        return true
      else
        log "#{number}: show not published yet"
        return false
      end
    end

  end
end