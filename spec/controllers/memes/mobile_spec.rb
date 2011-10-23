require 'spec_helper'

describe MemesController do
  render_views
  let!(:show) { Factory(:show) }
  let!(:meme) { Factory(:meme) }
  let!(:note) { Factory(:note, :meme => meme, :show => show) }

  before do
    Browser.any_instance.stub(:iphone?).and_return(true)
  end

  describe "GET index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET top" do
    subject { get :top }
    it { should be_success }
  end

end
