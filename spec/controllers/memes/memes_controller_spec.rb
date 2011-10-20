require 'spec_helper'

describe MemesController do
  render_views
  let(:resource) { Factory(:meme) }

  describe "GET :index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET :show" do
    subject { get :show, :id => resource.id }
    it { should be_success }
  end

  describe "XHR GET :show" do
    subject { xhr :get, :show, :id => resource.id }
    it { should be_success }
  end

  context "API" do
    ['xml','json'].each do |format|
      describe "GET :index.#{format}" do
        subject { get :index, :format => format }
        it { should be_success }
      end
      describe "GET :show.#{format}" do
        subject { get :show, :id => resource.id, :format => format }
        it { should be_success }
      end
    end
  end

  context "nested under show" do
    let!(:show) { Factory(:show) }
    let!(:note) { Factory(:note, :show => show, :meme => resource) }
    describe "GET :index" do
      subject { get :index, :show_id => show.number }
      it { should be_success }
    end
    
    describe "GET :show" do
      subject { get :show, :show_id => show.number, :id => resource.id }
      it { should be_success }
    end
  end
end
