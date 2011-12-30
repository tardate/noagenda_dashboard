require 'spec_helper'
require 'support/scraper_mocks'
include ScraperMocksHelper

describe "Navd::Scraper::Control" do
  let(:scraper_control) { Navd::Scraper::Control.new }

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
    subject { scraper_control.load_show(show_number) }
    before {
      Navd::Scraper::Spider.any_instance.stub(:get_page).and_return(published_show_page_html)
      Navd::Scraper::ShowLoader.any_instance.stub(:show_notes).and_return([])
      Navd::Scraper::ShowLoader.any_instance.stub(:credits_list).and_return(nil)
    }
    it "should create show record" do
      expect { subject }.to change { Show.count }.from(0).to(1)
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
