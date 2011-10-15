require "spec_helper"

class ScraperSupportTestHarness
  include Navd::Scraper::Support
end

describe "Navd::Scraper::Support" do
  
  context "common instance methods" do
    let(:object_with_support) { ScraperSupportTestHarness.new }
    subject { object_with_support }

    [
      :normalize_uri
    ].each do |method|
      it "should respond to #{method}" do
        subject.should respond_to(method)
      end
    end

    describe "#normalize_uri" do
      it "should return a URI object" do
        subject.normalize_uri('http://example.net').should be_a(URI)
        
      end
    end
  end

end