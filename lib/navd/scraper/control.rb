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
    # +reload+ - will do a fresh load of the show if true
    def load_show(number,reload=false)
      log "#{number}: loading show#{ reload ? ' [reload enabled]' : ' [reload disabled]'}"
      show_loader = Navd::Scraper::ShowLoader.new(number)
      show_loader.scan_show_assets
      if show_loader.errors.present?
        log "#{number}: errors: #{show_loader.errors.inspect}"
        return false
      end
      if show_loader.published
        show = Show.find_or_initialize_by_number(number)
        if reload || show.new_record?
          show.update_attributes!(show_loader.attributes)
          show.notes.destroy_all # we'll reload if they already exist
          show_loader.show_notes.each do |show_note|
            meme = Meme.factory(show_note[:meme_name])
            note = Note.find_or_initialize_by_show_id_and_name(show.id,show_note[:name])
            note.update_attributes!(
              :url => show_note[:url],
              :meme_id => meme.try(:id),
              :description => show_note[:description]
            )
          end
          notify_new_show(show)
          return true
        else
          log "#{number}: show already published - cannot reload"
          return false
        end
      else
        log "#{number}: show not published yet"
        return false
      end
    end

    protected

    # Post notification of new show.
    # Currently posts to twitter.
    def notify_new_show(show)
      if config = twitter_oauth_config
        client = Grackle::Client.new(config)
        client.statuses.update! :status=>show.twitter_publish_message
      else
        log "#{show.try(:number)}: cannot post to twitter - missing config"
      end
    rescue => e
      log "#{show.try(:number)}: failed to post to twitter #{e}"
    end

    # Returns twitter oauth config. Gets settings from ENV vars.
    # Returns nil if no config available.
    def twitter_oauth_config
      if (consumer_key = ENV['navd_consumer_key']) && (consumer_secret = ENV['navd_consumer_secret']) &&
        (token = ENV['navd_token']) && (token_secret = ENV['navd_token_secret'])
        {:auth=>{
          :type=>:oauth,
          :consumer_key=>consumer_key, :consumer_secret=>consumer_secret,
          :token=>token, :token_secret=>token_secret}
        }
      end
    end
  end
end