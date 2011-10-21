require 'spec_helper'

describe Meme do
  let(:resource) { Factory(:meme) }
  subject { Meme }

  it_behaves_like "has a valid test factory", :meme, Meme

  it_behaves_like "having associations", Meme, {
    :notes             => :has_many,
    :shows             => :has_many
  }
  describe "##STAT_CHART_TEMPLATE" do
    subject { Meme::STAT_CHART_TEMPLATE }
    it { should be_a(Hash) }
  end

  describe "#shows" do
    let!(:show) { Factory(:show) }
    before { 3.times { Factory.create(:note, :show => show, :meme => resource)} }
    subject { resource.shows }
    its(:count) { should eql(1) }
    it { should include(show) }
  end

  describe "##select_listing" do
    let!(:meme_a) { Factory(:meme, :name => 'aaa') }
    let!(:meme_b) { Factory(:meme, :name => 'bbb') }
    subject { Meme.select_listing }
    its(:first) { should eql(meme_a) }
    its(:last) { should eql(meme_b) }
  end

  describe "##normalize_name" do
    {
      :unknown_value => { :given => 'unique', :expect => 'unique' },
      :false_flag_alt1 => { :given => 'UK false flag', :expect => 'Fal$e Flag' },
      :false_flag_alt2 => { :given => 'false flag', :expect => 'Fal$e Flag' },
      :false_flag_alt3 => { :given => 'Fal$e flag', :expect => 'Fal$e Flag' }
    }.each do |test_name,options|
      context "with #{test_name} given #{options[:given]} then expect #{options[:expect]}" do
        subject { Meme.normalize_name(options[:given]) }
        it { should eql(options[:expect])}
      end
    end
  end

  describe "##factory" do
    let(:existing) { Factory(:meme) }
    it "should create the meme if it doesn't already exist" do
      expect { Meme.factory('33') }.to change { Meme.count }.from(0).to(1)
    end
    it "should use existing meme name if it already exists" do
      Meme.factory(existing.name).should eql(existing)
    end
    it "should normalize the meme name as required" do
      Meme.stub(:normalize_name).and_return('Normalized')
      Meme.factory('33').name.should eql('Normalized')
    end
  end

  describe "#destroy" do
    let!(:meme) { Factory(:meme) }
    let!(:show) { Factory(:show) }
    let!(:note) { Factory(:note, :show => show, :meme => meme ) }
    subject { meme.destroy }
    it "should not remove related shows" do
      expect { subject }.not_to change { Show.count }
    end
    it "should remove related notes" do
      expect { subject }.to change { Note.count }.from(1).to(0)
    end
  end
end
