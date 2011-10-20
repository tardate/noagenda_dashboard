require 'spec_helper'

describe NotesController do
  render_views
  let!(:show) { Factory(:show) }
  let!(:meme) { Factory(:meme) }
  let!(:note) { Factory(:note, :show => show, :meme => meme) }
  let(:resource) { note }

  describe "GET index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET show" do
    subject { get :show, :id => resource.id }
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
    describe "GET :index" do
      subject { get :index, :show_id => show.number }
      it { should be_success }
    end
    
    describe "GET :show" do
      subject { get :show, :show_id => show.number, :id => resource.id }
      it { should be_success }
    end
  end
  
  context "nested under meme" do
    describe "GET :index" do
      subject { get :index, :meme_id => meme.id }
      it { should be_success }
    end
    
    describe "GET :show" do
      subject { get :show, :meme_id => meme.id, :id => resource.id }
      it { should be_success }
    end
  end
end
