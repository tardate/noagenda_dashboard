require 'spec_helper'

describe "Navd::Scraper" do
  context "init" do
    let(:scraper) { Navd::Scraper.new }
    subject { scraper }
    it { should_not be_nil }
  end
end
