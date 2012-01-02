module ::Navd::Scraper
  class ShowLoader
    attr_accessor :number, :spider, :uri, :found, :published, :errors
    attr_reader :attributes, :show_notes

    attr_reader :p_shownotes_main # Nokogiri::HTML::Document of the main shownotes page being processed

    # +number+ - show number to load
    def initialize(number)
      @errors = []
      @number = number
      @attributes = {}
      @show_notes = []
      @spider = Navd::Scraper::Spider.new
    end

    # Returns true if show details have been scraped without error
    def loaded?
      found && errors.empty?
    end

    # Loads all the show details for given show
    # If an error is encountered, +@errors+ will be present and method will return false
    def scan_show_assets
      @uri, @p_shownotes_main = spider.get_page_for_show(number)
      if spider.errors.present?
        @errors += spider.errors
        return false
      end
      @found = true
      @attributes = {
        :number => number,
        :show_notes_url => uri.to_s,
        :audio_url => mp3_url,
        :published => mp3_url.present?
      }
      unless @published = @attributes[:published]
        @errors << 'show is not yet published'
        return false
      end
      @attributes.merge!({
        :published_date => published_date,
        :cover_art_url => cover_art_url,
        :assets_url => assets_url,
        :url => episode_url,
        :credits => credits,
        :name => show_name
      })
      show_notes
      errors.empty?
    end

    # Returns an array of hashes with show note detail (:name,:meme_name,:description,:url)
    # This is probably the dodgiest bit of the parsing. If something goes wrong, exceptions are left unhandled
    def show_notes
      return @show_notes if @show_notes.present?
      @show_notes = case shownotes_format
      when :nested
        get_nested_show_notes
      when :flat
        get_flat_show_notes
      else
        []
      end
    end

    protected

    def get_nested_show_notes
      notes = []
      current_meme = nil
      show_notes_collection(:nested).each do |n|
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
                :name => current_title.truncate(255),
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

    def get_flat_show_notes
      show_notes = []
      # scan all the top-level li elements under the shownotes node
      show_notes_collection(:flat).each do |n|
        if n.next_element && n.next_element.name=='div' && (current_meme = n.css('span').text)
          notes = n.next_element.xpath('./ul/li') # top level li elements
          notes.each do |note|
            current_title = note.text
            name = current_title.truncate(255)
            partial_description = current_title == name ? nil : current_title
            if (note_collection = note.next_element) && note_collection.name=='div' && (subnotes = note_collection.css('li'))
              note_count = 0
              note_template = {
                :name => name,
                :meme_name => current_meme,
                :description => partial_description,
                :url => nil
              }
              note_array = []
              subnotes.each do |subnote|
                if anchor = (subnote.at_css('a') || {})[:href]
                  note_count += 1
                  note_array << note_template.merge(:url => anchor)
                end
                if subnote.text.present?
                  if note_count == 0
                    note_count += 1
                    note_array << note_template.merge(:url => anchor)
                  end
                  note_array[note_count-1][:description] =
                    [note_array[note_count-1][:description],subnote.text].compact.join('<br/>')
                end
              end
              show_notes += note_array
            else
              anchor = (note.at_css('a') || {})[:href]
              show_notes << {
                :name => name,
                :meme_name => current_meme,
                :description => partial_description,
                :url => anchor
              }
            end
          end
        end
      end
      show_notes
    end

    def show_notes_collection(format = :flat)
      case format
      when :nested
        p_shownotes_detail_all.at_css('ul.ulDirectory').children
      when :flat
        p_shownotes_menu.css('div.divOutlineBody > ul > li').map{|n| n.at_css('span').text =~ /notes/i ? n.next_element : nil }.compact.first.xpath('./ul/li')
      else
        []
      end
    end

    def show_credits_collection(format = :flat)
      case format
      when :nested
        p_credits.css('.directoryComment').children
      when :flat
        p_shownotes_menu.css('div.divOutlineBody > ul > li').map{|n| n.at_css('span').text =~ /credit/i ? n.next_element : nil }.compact.first.css('*').children
      else
        []
      end
    end

    # Returns an array of credit items given an Nokogiri::HTML::Document container node
    def normalize_credit_list(collection_root)
      nbsp = Nokogiri::HTML("&nbsp;").text
      c = collection_root.map{|c| c.is_a?(Nokogiri::XML::Text) ? c.text.gsub(nbsp,' ').gsub(/\t|\n/,'') : nil }
      c.reject!{|i| i.blank?}
      c
    end

    # Returns a text representation of the show credits
    def credits
      @credits ||= credits_list.try(:join,'<br/>')
    end
    # Returns an array of credits for the show
    def credits_list
      @credits_list ||= normalize_credit_list(show_credits_collection(shownotes_format))
    end

    # Returns the human name of the show
    def show_name
      case number
      when 368 # special case
        'Too Many Clips'
      else
        credits_list.try(:first)
      end
    end

    # Returns the show date (as extracted from the audio file name)
    # Dodgy approach, but seems the most reliable way of automatically getting the show date
    def published_date
      # cheat, we get from the audio file name
      mdy=mp3_url.match( /noagenda-\d*-(\d+)-(\d+)-(\d+)/ )
      Date.parse("#{mdy[3]}-#{mdy[1]}-#{mdy[2]}")
    rescue Exception => e
      @errors << e
      nil
    end

    # Returns the link to audio file from the main shownotes page
    # e.g. http://m.podshow.com/media/15412/episodes/299798/noagenda-299798-10-20-2011.mp3
    def mp3_url
      @mp3_url ||= extract_nodes(p_shownotes_main,:mp3)[:href]
    end

    # Returns the link to official show page
    # e.g. http://blog.curry.com/stories/2011/10/20/na34920111020.html
    def episode_url
      @episode_url ||= extract_nodes(p_shownotes_main,:web)[:href]
    end

    # Returns the link to cover art
    # e.g. http://dropbox.curry.com/ShowNotesArchive/2011/10/NA-349-2011-10-20/Assets/ns349art.png
    def cover_art_url
      @cover_art_url ||= extract_nodes(p_shownotes_main,:cover_art)[:href]
    end

    # Returns the link to show assets page
    # e.g. http://349.nashownotes.com/assets
    def assets_url
      @assets_url ||= uri.merge(extract_nodes(p_shownotes_main,:assets)[:href]).to_s
    rescue
      # ignore errors getting the asset url
    end

    # Returns the URI to show credits page
    # http://349.nashownotes.com/shownotes/na34920111020Credits
    def credits_uri
      @credits_uri ||= uri.merge(extract_nodes(p_shownotes_menu,:credits)[:href])
    rescue
      # ignore errors getting the asset url
    end
    # Returns the nested shownotes page content
    # e.g. http://349.nashownotes.com/shownotes ->
    #      http://349.nashownotes.com/shownotes/na34920111020Credits
    def p_credits
      @p_credits ||= spider.get_page(credits_uri)
    end

    # Returns the URI to show notes menu page
    # e.g. http://349.nashownotes.com/shownotes
    def shownotes_menu_uri
      @shownotes_menu_uri ||= uri.merge(extract_nodes(p_shownotes_main,:notes)[:href])
    rescue
      # ignore errors getting the asset url
    end
    # Returns Nokogiri::HTML::Document of the main shownotes menu page being processed
    def p_shownotes_menu
      @p_shownotes_menu ||= shownotes_menu_uri && spider.get_page(shownotes_menu_uri)
    end
    # Returns the shownote menu page format type.
    # Currently supports:
    #   :nested - as for shows ~325-361
    #   :flat - shows 362+
    def shownotes_format
      @shownotes_format ||= if p_shownotes_menu
        if p_shownotes_menu.css('ul.ulDirectory').present?
          :nested
        else
          :flat
        end
      else
        nil
      end
    end

    def shownotes_detail_main_uri
      uri.merge(extract_nodes(p_shownotes_menu,:notes)[:href])
    end
    def shownotes_detail_all_uri
      p_shownotes_detail_main = spider.get_page(shownotes_detail_main_uri)
      uri.merge(extract_nodes(p_shownotes_detail_main,:all_notes)[:href])
    end
    # Returns the nested shownotes page content
    # e.g. http://349.nashownotes.com/shownotes ->
    #      http://349.nashownotes.com/shownotes/na34920111020Shownotes ->
    #      http://349.nashownotes.com/shownotes/na34920111020Shownotes/expandAllTopics
    def get_nested_shownotes_page
      spider.get_page(shownotes_detail_all_uri)
    end
    # Returns the shownotes HTML
    def p_shownotes_detail_all
      @p_shownotes_detail_all ||= case shownotes_format
      when :nested
        get_nested_shownotes_page
      when :flat
      end
    end

    # Set of algorithms to extracts parts of a page
    # +page+ is a Nokogiri::HTML::Document
    # +item+ - symbol for note type required
    def extract_nodes(page,item)
      result = case item
      when :all_notes
        page.css('a.directoryLink').select{|n| n.text[/expand all/i] }.first
      when :credits
        page.css('a.directoryLink').select{|n| n.text[/credits/i] }.first
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