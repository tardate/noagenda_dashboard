require 'spec_helper'

describe Meme do
  let(:resource) { Factory(:meme) }
  subject { Meme }

  describe "##top10" do
    subject { Meme.top10 }
    before {
      (1..20).each do |i|
        m = Factory.create(:meme, :name => i.to_s )
        i.times { Factory.create(:note, :meme => m) }
      end
    }
    its(:count) { should eql(10) }
    it "should only include the top 10 memes" do
      subject.map{|m| m.name.to_i }.min.should eql(11)
    end
  end

  describe "##stats_over_time" do
    subject { Meme.stats_over_time }
    let!(:show) { Factory.create(:show, :number => 33 ) }
    before {
      (1..20).each do |i|
        m = Factory.create(:meme, :name => i.to_s )
        i.times { Factory.create(:note, :meme => m, :show => show) }
      end
    }
    it { subject.to_a.count.should eql(10) }
    it "should count notes correctly" do
      subject.first[:meme_name].should eql("11")
      subject.first[:number].should eql("33")
      subject.first[:note_count].should eql("11")
      subject.last[:meme_name].should eql("20")
      subject.last[:number].should eql("33")
      subject.last[:note_count].should eql("20")
    end
  end
end