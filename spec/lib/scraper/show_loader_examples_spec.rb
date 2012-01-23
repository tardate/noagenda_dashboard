require 'spec_helper'
include ScraperMocksHelper

describe "Navd::Scraper::ShowLoader examples" do
  let(:show_loader) { Navd::Scraper::ShowLoader.new(show_number) }
  subject { show_loader }

  # test the scanning on samples in spec/fixtures/html/<show number>
  describe "#scan_show_assets" do
    {
      '333' => {
        :expected_attributes => {
          :number => 333,
          :published => true,
          :show_notes_url=>"http://333.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/293390/noagenda-293390-08-25-2011.mp3",
          :published_date=>Date.parse('2011-8-25'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/08/NA-333-2011-08-25/Assets/na333art.png",
          :assets_url=>"http://333.nashownotes.com/assets",
          :url=>"http://blog.curry.com/stories/2011/08/25/na33320110825.html",
          :credits=>nil,
          :name=>nil
        },
        :shownotes_format => :nested,
        :shownotes_menu_url => 'http://333.nashownotes.com/shownotes',
        :shownotes_count => 94,
        :show_name => 'Lions Stood Still',
        :credits=>%(Lions Stood Still<br/>Executive Producers: Bryan Raley, Alan Thompson, Michael Kearns, Oscar Nadal, Richard Hyde, Robert Claeson, Scott Hankel, Jrdan Wyatt<br/>Associate Executive Producers:  Scott Hankel<br/>),
        :credits_url => 'http://333.nashownotes.com/shownotes/na33320110825Credits'
      },
      '362' => {
        :expected_attributes => {
          :number => 362,
          :published => true,
          :show_notes_url=>"http://362.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/304727/noagenda-304727-12-04-2011.mp3",
          :published_date=>Date.parse('2011-12-04'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/12/NA-362-2011-12-04/Assets/na362art.jpg",
          :assets_url=>"http://362.nashownotes.com/assets",
          :url=>"http://blog.curry.com/stories/2011/12/04/na36220111204.html",
          :credits=>nil,
          :name=>nil
        },
        :shownotes_format => :flat,
        :shownotes_menu_url => 'http://362.nashownotes.com/shownotes',
        :shownotes_count => 59,
        :show_name => 'Drone Journalism',
        :credits=>%(Drone Journalism<br/>Executive Producers: Adam Curry & John C Dvroak<br/>),
        :credits_url => nil
      },
      '364' => {
        :expected_attributes => {
          :number => 364,
          :published => true,
          :show_notes_url=>"http://364.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/305637/noagenda-305637-12-11-2011.mp3",
          :published_date=>Date.parse('2011-12-11'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/12/NA-364-2011-12-11/Assets/na364art.jpg",
          :assets_url=>nil,
          :url=>"http://blog.curry.com/stories/2011/12/11/na36420111211.html",
          :credits=>nil,
          :name=>nil
        },
        :shownotes_format => :flat,
        :shownotes_menu_url => 'http://364.nashownotes.com/shownotes',
        :shownotes_count => 90,
        :show_name => 'Katy Bar The Door, Baby!',
        :credits=>%(Katy Bar The Door, Baby!<br/>Executive Producers: Sir Richard Scott Bagwell),
        :credits_url => nil
      },
      '368' => {
        :expected_attributes => {
          :number => 368,
          :published => true,
          :show_notes_url=>"http://xmas2011.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/307185/noagenda-307185-12-25-2011.mp3",
          :published_date=>Date.parse('2011-12-25'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2011/12/NA-Christmas%20Cliptacular/NA_CLIP_REEL.png",
          :assets_url=>nil,
          :url=>"http://blog.curry.com/stories/2011/12/25/naChristmasCliptacular.html",
          :credits=>nil,
          :name=>'Too Many Clips'
        },
        :shownotes_format => nil,
        :shownotes_menu_url => nil,
        :shownotes_count => 0,
        :show_name => 'Too Many Clips',
        :credits=> "",
        :credits_url => nil
      },
      '373' => {
        :expected_attributes => {
          :number => 373,
          :published => true,
          :show_notes_url=>"http://373.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/308608/noagenda-308608-01-12-2012.mp3",
          :published_date=>Date.parse('2012-01-12'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2012/01/NA-373-2012-01-12/Assets/na373art.jpg",
          :assets_url=>'http://373.nashownotes.com/assets',
          :url=>"http://blog.curry.com/stories/2012/01/12/na37320120112.html",
          :credits=>nil,
          :name=>nil
        },
        :shownotes_format => :flat,
        :shownotes_menu_url => 'http://373.nashownotes.com/shownotes',
        :shownotes_count => 52,
        :show_name => 'Paraphilia',
        :credits=> %(Executive Producer: Sir David Overbeck),
        :credits_url => nil
      },
      '374' => {
        :expected_attributes => {
          :number => 374,
          :published => true,
          :show_notes_url=>"http://374.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/308814/noagenda-308814-01-15-2012.mp3",
          :published_date=>Date.parse('2012-01-15'),
          :cover_art_url=>"http://dropbox.curry.com/ShowNotesArchive/2012/01/NA-374-2012-01-15/Assets/na374art.jpg",
          :assets_url=>nil,
          :url=>"http://374.nashownotes.com/",
          :credits=>nil,
          :name=>'Fractals on the Bone'
        },
        :shownotes_format => :p374,
        :shownotes_count => 41,
        :show_name => 'Fractals on the Bone',
        :credits=> %(Executive Producers: Sir Martin Anderson, Andrew),
        :credits_url => nil
      },
      '375' => {
        :expected_attributes => {
          :number => 375,
          :published => true,
          :show_notes_url=>"http://375.nashownotes.com/",
          :audio_url=>"http://m.podshow.com/media/15412/episodes/309141/noagenda-309141-01-19-2012.mp3",
          :published_date=>Date.parse('2012-01-19'),
          :cover_art_url=>"http://blog.curry.com/images/2012/01/19/na375art_big.jpg",
          :assets_url=>nil,
          :url=>"http://375.nashownotes.com/",
          :credits=>nil,
          :name=>'Problematic Woman'
        },
        :shownotes_format => :p374,
        :shownotes_count => 65,
        :show_name => 'Problematic Woman',
        :credits=> %(Executive Producers: Sir Michael Miller),
        :credits_url => nil
      }
    }.each do |number,options|
      context "show ##{number}" do
        let(:show_number) { number.to_i }
        let(:expected_attributes) { options[:expected_attributes] }

        context "excluding credits" do
          before {
            show_loader.spider.stub(:get_page).and_return(published_show_page_html(show_number))
            show_loader.stub(:p_shownotes_menu).and_return(shownotes_menu_page_html(show_number))
            show_loader.stub(:get_nested_shownotes_page).and_return(shownotes_detail_page_html(show_number))
            show_loader.stub(:credits_list).and_return(nil)
            show_loader.scan_show_assets
          }
          its(:found) { should be_true }
          its(:published) { should be_true }
          its(:errors) { should be_empty }
          its(:attributes) { should eql(expected_attributes) }
          
          describe "#shownotes_menu_uri [protected]" do
            subject { show_loader.send(:shownotes_menu_uri) }
            let(:expected) { options[:shownotes_menu_url] ? URI.parse(options[:shownotes_menu_url]) : nil }
            it { should eql(expected) }
          end
          
          describe "#shownotes_format [protected]" do
            subject { show_loader.send(:shownotes_format) }
            it { should eql(options[:shownotes_format]) }
          end

          describe "#show_notes" do
            subject { show_loader.show_notes }
            its(:count) { should eql(options[:shownotes_count]) }
          end

        end

        context "with credits" do
          before {
            show_loader.spider.stub(:get_page).and_return(published_show_page_html(show_number))
            show_loader.stub(:p_shownotes_menu).and_return(shownotes_menu_page_html(show_number))
            show_loader.stub(:get_nested_show_notes).and_return([])
            show_loader.stub(:p_credits).and_return(credits_page_html(show_number))
            show_loader.scan_show_assets
          }

          describe "#show_name [protected]" do
            subject { show_loader.send(:show_name) }
            let(:expected) { options[:show_name] }
            it { should eql(expected) }
          end

          describe "#credits_uri [protected]" do
            subject { show_loader.send(:credits_uri) }
            if options[:credits_url]
              let(:expected) { URI.parse(options[:credits_url]) }
              it { should eql(expected) }
            else
              it { should be_nil }
            end
          end

          describe "#credits [protected]" do
            subject { show_loader.send(:credits) }
            if options[:credits].present?
              let(:expected) { options[:credits] }
              it { should include(expected) }
            else
              it { should be_empty }
            end
          end

        end

      end
    end
  end
end