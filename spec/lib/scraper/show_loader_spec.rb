require 'spec_helper'
require 'support/scraper_mocks'
include ScraperMocksHelper

describe "Navd::Scraper::ShowLoader" do
  let(:show_number) { 333 }
  let(:show_loader) { Navd::Scraper::ShowLoader.new(show_number) }
  subject { show_loader }

  context "init" do
    it { should_not be_nil }
    its(:number) { should eql(show_number) }
    its(:spider) { should be_a(Navd::Scraper::Spider) }
    its(:found) { should be_nil }
    its(:published) { should be_nil }
  end

  context "unpublished show" do
    let(:show_number) { 33 }
    before {
      show_loader.spider.stub(:get_page).and_return(unpublished_show_page_html)
      show_loader.stub(:show_notes).and_return([])
      show_loader.scan_show_assets
    }
    its(:found) { should be_true }
    its(:published) { should be_false }
    its(:errors) { should_not be_empty }
  end

  context "bad url" do
    before {
      show_loader.spider.stub(:get_uri_for_show).and_return('bad://karma')
      show_loader.stub(:show_notes).and_return([])
      show_loader.scan_show_assets
    }
    its(:found) { should be_false }
    its(:published) { should be_false }
    its(:errors) { should_not be_empty }
  end

  describe "#show_name (protected)" do
    let(:expected) { 'show name' }
    subject { show_loader.send(:show_name) }
    before { show_loader.stub(:credits_list).and_return([expected,'','']) }
    it { should eql(expected) }
  end
end
