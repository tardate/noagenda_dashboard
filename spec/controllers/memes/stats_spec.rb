require 'spec_helper'

describe MemesController do
  render_views
  let(:resource) { Factory(:meme) }

  describe "GET :stats.json" do
    subject { get :stats, :format => 'json' }
    it { should be_success }
  end

  describe "GET :stat.json" do
    subject { get :stat, :id => resource.id, :format => 'json' }
    it { should be_success }
  end

end
