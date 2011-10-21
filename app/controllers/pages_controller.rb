class PagesController < ApplicationController
  layout lambda { |controller| controller.request.xhr? ? false : 'application' }

end