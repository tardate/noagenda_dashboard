require 'spec_helper'

describe MemesController do
  render_views
  let(:resource) { Factory(:meme) }

  describe "GET :stats.json" do
    subject { get :stats, :format => 'json' }
    it { should be_success }
  end

end
