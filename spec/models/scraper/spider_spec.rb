require 'spec_helper'

describe "Navd::Scraper::Spider" do
  let(:spider) { Navd::Scraper::Spider.new }

  context "init" do
    subject { spider }
    it { should_not be_nil }
    its(:errors) { should be_empty }
  end

  describe "#get_uri_for_show" do
    context "new nashownotes convention" do
      [333,340].each do |show_number|
        context "show #{show_number}" do
          subject { spider.get_uri_for_show(show_number) }
          it { should be_a(URI) }
          it "should have the conventional form" do
            subject.to_s.should eql("http://#{show_number}.nashownotes.com/")
          end
        end
      end
    end
    context "bad uri" do
      let(:show_number) { 'bad^karma' }
      subject { spider.get_uri_for_show(show_number) }
      it { should be_nil }
      it "should record the error" do
        subject
        spider.errors.should_not be_empty
      end
    end
  end

  describe "#get_page" do
    let(:uri) { spider.get_uri_for_show(333) }
    subject { spider.get_page(uri) }
    it { should be_a(Nokogiri::HTML::Document) }
    context "bad uri" do
      let(:uri) { 'bad:://karma' }
      it { should be_nil }
      it "should record the error" do
        subject
        spider.errors.should_not be_empty
      end
    end
  end

end