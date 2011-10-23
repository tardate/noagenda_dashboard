class ApplicationController < ActionController::Base
  layout lambda { |controller| controller.request.xhr? ? false : 'application' }
  protect_from_forgery

  helper_method :mobile_device?, :smartphone?, :tablet?

  before_filter :set_request_format

  protected

    def mobile_device?
      browser.ios? || browser.android?
    end
    def smartphone?
      browser.iphone? || browser.android?
    end
    def tablet?
      browser.ipad?
    end
    def set_request_format
      if smartphone?
        request.format = :mobile
      end
    end

end
