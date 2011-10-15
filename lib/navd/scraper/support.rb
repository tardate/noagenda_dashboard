require 'uri'
require 'open-uri'

module ::Navd::Scraper
  module Support
    extend ActiveSupport::Concern

    module InstanceMethods

      def normalize_uri( url )
        url = "http://#{url}" unless url =~ /^http[s]?:\/\//
    		URI.parse( url )
      end
    end

  end
end