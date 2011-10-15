require 'spec_helper'

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
    context "real example page" do
      before { show_loader.scan_show_assets }
      its(:found) { should be_true }
      its(:published) { should be_false }
    end

    context "unpublished show" do
      let(:show_number) { 33 }
      before { show_loader.scan_show_assets }
      its(:found) { should be_true }
      its(:published) { should be_false }
    end
    context "bad url" do
      let(:show_number) { 'bad^karma' }
      before { show_loader.scan_show_assets }
      its(:found) { should be_false }
      its(:published) { should be_false }
    end
  end

  
end
