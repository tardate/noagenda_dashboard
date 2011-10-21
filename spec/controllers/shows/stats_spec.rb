require 'spec_helper'

describe ShowsController do
  render_views
  let(:resource) { Factory(:show) }

  describe "GET :stat.json" do
    subject { get :stat, :id => resource.id, :format => 'json' }
    it { should be_success }
  end

end
