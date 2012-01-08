require 'spec_helper'

describe VideosController do
  render_views
  let!(:video_meme) { Factory(:meme, :name => 'VIDEO') }
  let!(:show) { Factory(:show) }
  let!(:resource) { Factory(:note, :show => show, :meme => video_meme) }
  
  context "RSS" do
    describe "GET :index.rss" do
      subject { get :index, :format => 'rss' }
      it { should be_success }
    end

    context "nested under show" do
      describe "GET :index.rss" do
        subject { get :index, :format => 'rss', :show_id => show.number }
        it { should be_success }
      end
    end
  end

end
