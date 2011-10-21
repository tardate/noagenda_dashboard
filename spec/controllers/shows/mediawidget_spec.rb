require 'spec_helper'

describe ShowsController do
  render_views
  let(:resource) { Factory(:show) }

  describe "XHR GET mediawidget" do
    subject { xhr :get, :mediawidget, :id => resource.number }
    it { should be_success }
  end

end
