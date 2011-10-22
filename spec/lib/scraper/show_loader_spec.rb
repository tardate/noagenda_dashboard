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

  describe "#scan_show_assets" do

    context "published show" do
      let(:expected_attributes) { {
        :number => 333,
        :published => true,
        :show_notes_url=>"http://333.nashownotes.com/",
        :audio_url=>"http://m.podshow.com/media/15412/episodes/293390/noagenda-293390-08-25-2011.mp3",
        :published_date=>Date.parse('2011-8-25'),
        :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/08/NA-333-2011-08-25/Assets/na333art.png",
        :assets_url=>"http://333.nashownotes.com/assets",
        :url=>"http://blog.curry.com/stories/2011/08/25/na33320110825.html",
        :credits=>nil
      } }
      before {
        show_loader.spider.stub(:get_page).and_return(Nokogiri::HTML(published_show_page_html))
        show_loader.stub(:show_notes).and_return([])
        show_loader.stub(:credits).and_return(nil)
        show_loader.scan_show_assets
      }
      its(:found) { should be_true }
      its(:published) { should be_true }
      its(:errors) { should be_empty }
      its(:attributes) { should eql(expected_attributes) }

      describe "#shownotes_menu_uri [protected]" do
        subject { show_loader.send(:shownotes_menu_uri) }
        let(:expected) { URI.parse('http://333.nashownotes.com/shownotes') }
        it { should eql(expected) }
      end

      context "parsing shownotes menu" do
        before {
          show_loader.stub(:p_shownotes_menu).and_return(Nokogiri::HTML(shownotes_menu_page_html))
        }
        describe "#shownotes_detail_main_uri [protected]" do
          subject { show_loader.send(:shownotes_detail_main_uri) }
          let(:expected) { URI.parse('http://333.nashownotes.com/shownotes/na33320110825Shownotes') }
          it { should eql(expected) }
        end
        describe "#credits_uri [protected]" do
          subject { show_loader.send(:credits_uri) }
          let(:expected) { URI.parse('http://333.nashownotes.com/shownotes/na33320110825Credits') }
          it { should eql(expected) }
        end
      end
    end

    context "parsing credits" do
      before {
        show_loader.stub(:p_credits).and_return(Nokogiri::HTML(credits_page_html))
      }
      describe "#credits [protected]" do
        subject { show_loader.send(:credits) }
        let(:expected) {
          %(Lions Stood Still<br/>Executive Producers: Bryan Raley, Alan Thompson, Michael Kearns, Oscar Nadal, Richard Hyde, Robert Claeson, Scott Hankel, Jrdan Wyatt<br/>Associate Executive Producers:  Scott Hankel<br/>Executive Producers and 333  Club members: Bryan Raley, Alan Thompson, Michael Kearns, Oscar Nadal, Richard Hyde, Robert Claeson, Scott Hankel<br/>Knighthoods: Jordan Wyatt<br/>Art By: Thoren)
        }
        it { should eql(expected) }
      end
    end

    context "unpublished show" do
      let(:show_number) { 33 }
      before {
        show_loader.spider.stub(:get_page).and_return(Nokogiri::HTML(unpublished_show_page_html))
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
  end
  
end
