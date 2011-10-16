require 'spec_helper'

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
      Navd::Scraper::Spider.any_instance.stub(:get_page).and_return(Nokogiri::HTML(published_show_page_html))
      Navd::Scraper::ShowLoader.any_instance.stub(:extract_show_notes).and_return([])
    }
    it "should create show record" do
      expect { subject }.to change { Show.count }.from(0).to(1)
    end
  end
end
