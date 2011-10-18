require 'spec_helper'

describe Meme do
  subject { Meme }

  it_behaves_like "has a valid test factory", :meme, Meme

  it_behaves_like "having associations", Meme, {
    :notes             => :has_many,
    :shows             => :has_many
  }

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
      :false_flag_alt3 => { :given => 'fal$e flag', :expect => 'Fal$e Flag' }
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
end
