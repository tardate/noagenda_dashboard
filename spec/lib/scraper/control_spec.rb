require 'spec_helper'
require 'support/scraper_mocks'
include ScraperMocksHelper

describe "Navd::Scraper::Control" do
  let(:scraper_control) { Navd::Scraper::Control.new }
  before {
    scraper_control.stub(:log) # silence the logging messages when testing
    scraper_control.stub(:notify_new_show) # silence the tweeting of show posts when testing
  }

  context "init" do
    subject { scraper_control }
    it { should_not be_nil }
    describe "#options" do
      context "default" do
        subject { scraper_control.options }
        it { should be_a(Hash) }
      end
    end
  end

  describe "#load_show" do
    let(:show_number) { 333 }
    let(:show_attributes) { {
      :number => show_number,
      :published => true,
      :show_notes_url=>"http://333.nashownotes.com/",
      :audio_url=>"http://m.podshow.com/media/15412/episodes/293390/noagenda-293390-08-25-2011.mp3",
      :published_date=>Date.parse('2011-8-25'),
      :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/08/NA-333-2011-08-25/Assets/na333art.png",
      :assets_url=>"http://333.nashownotes.com/assets",
      :url=>"http://blog.curry.com/stories/2011/08/25/na33320110825.html",
      :credits=>"some credits",
      :name=>"show name"
    } }
    let(:show_notes) { [
      {:name => "show note 1", :meme_name => "sample meme", :description => "description", :url => "http://www.example.com/"}
    ] }
    before {
      Navd::Scraper::ShowLoader.any_instance.stub(:scan_show_assets)
      Navd::Scraper::ShowLoader.any_instance.stub(:published).and_return(true)
      Navd::Scraper::ShowLoader.any_instance.stub(:attributes).and_return(show_attributes)
      Navd::Scraper::ShowLoader.any_instance.stub(:show_notes).and_return(show_notes)
    }
    context "with reload=false" do
      subject { scraper_control.load_show(show_number) }
      it "should create show record" do
        expect { subject }.to change { Show.count }.from(0).to(1)
      end
      it "should create show notes" do
        expect { subject }.to change { Note.count }.from(0).to(1)
      end
      it "should attempt to tweet" do
        scraper_control.should_receive(:notify_new_show).once
        subject
      end
      context "when attempting to load the show again" do
        before { scraper_control.load_show(show_number) }
        it "should not update the show details" do
          Show.any_instance.should_receive(:update_attributes!).never
          scraper_control.load_show(show_number)
        end
      end
    end
    context "when reloading" do
      before { scraper_control.load_show(show_number,true) }
      it "should update the show details" do
        Show.any_instance.should_receive(:update_attributes!).once
        scraper_control.load_show(show_number,true)
      end
      it "should not attempt to tweet" do
        scraper_control.should_receive(:notify_new_show).never
        scraper_control.load_show(show_number,true)
      end
    end
  end

  describe '#load_all_shows' do
    let(:first_show_number) { AppConstants.earliest_show_to_load }
    subject { scraper_control.load_all_shows }
    it "should start loading from AppConstants.earliest_show_to_load" do
      scraper_control.stub(:load_show).with(first_show_number).and_return(false)
      subject
    end
  end
end
