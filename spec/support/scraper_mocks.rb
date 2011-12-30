require 'pathname'

module ScraperMocksHelper

  def html_mock_path
    Pathname.new(File.dirname(__FILE__)).join('..','fixtures','html')
  end
  def mock_text(*path_elements)
    IO.read(html_mock_path.join(*path_elements))
  end
  def mock_html(*path_elements)
    Nokogiri::HTML(mock_text(*path_elements))
  end

  def unpublished_show_page_html
    mock_html('unpublished_show.htm')
  end

  def published_show_page_html(show_number=333)
    mock_html(show_number.to_s,'show.htm')
  end
  
  def shownotes_menu_page_html(show_number=333)
    mock_html(show_number.to_s,'shownotes_menu.htm')
  end

  def credits_page_html(show_number=333)
    mock_html(show_number.to_s,'credits.htm')
  end

end

# do not include automatically for models
# RSpec.configure do |conf|
#   conf.include ScraperMocksHelper, :type => :model
# end