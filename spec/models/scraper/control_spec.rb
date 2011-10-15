require 'spec_helper'

describe "Navd::Scraper::Control" do
  context "init" do
    let(:scraper_control) { Navd::Scraper::Control.new }
    subject { scraper_control }
    it { should_not be_nil }
    describe "#options" do
      context "default" do
        subject { scraper_control.options }
        it { subject[:show_note_roots].should_not be_empty }
      end
    end
  end

  describe "#" do
  end
end
