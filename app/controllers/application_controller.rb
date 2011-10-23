class ApplicationController < ActionController::Base
  layout lambda { |controller| controller.request.xhr? ? false : 'application' }
  protect_from_forgery
end
