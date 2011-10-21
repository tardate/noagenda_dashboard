require 'spec_helper'

describe Meme do
  let(:resource) { Factory(:meme) }
  let(:meme_limit) { AppConstants.number_of_trending_memes || 10 }
  let(:seed_limit) { meme_limit + 10 }
  let(:first_top_meme) { seed_limit - meme_limit + 1 }
  subject { Meme }

  describe "##topn" do
    subject { Meme.topn(meme_limit) }
    context "with more than n memes" do
      before {
        (1..seed_limit).each do |i|
          m = Factory.create(:meme, :name => i.to_s )
          i.times { Factory.create(:note, :meme => m) }
        end
      }
      its(:count) { should eql(meme_limit) }
      it "should only include the top memes" do
        subject.map{|m| m.name.to_i }.min.should eql(first_top_meme)
      end
    end
    context "with non-trending memes" do
      let!(:trending_meme) { Factory(:meme, :name => "trending") }
      let!(:non_trending_meme) { Factory(:meme, :name => "non-trending", :trending => false) }
      before {
        [trending_meme,non_trending_meme].each do |meme|
          Factory.create(:note, :meme => meme)
        end
      }
      it "should only include trending memes" do
        subject.map{|m| m.name }.should_not include(non_trending_meme.name)
      end
    end
  end

  describe "##stats_over_time" do
    let(:show_number) { 33 }
    subject { Meme.stats_over_time }
    let!(:show) { Factory.create(:show, :number => show_number ) }
    before {
      (1..seed_limit).each do |i|
        m = Factory.create(:meme, :name => i.to_s )
        i.times { Factory.create(:note, :meme => m, :show => show) }
      end
    }
    it { subject.to_a.count.should eql(meme_limit) }
    it "should count notes correctly" do
      subject.first[:meme_name].should eql("#{first_top_meme}")
      subject.first[:number].should eql(show_number.to_s)
      subject.first[:note_count].should eql("#{first_top_meme}")
      subject.last[:meme_name].should eql("#{seed_limit}")
      subject.last[:number].should eql(show_number.to_s)
      subject.last[:note_count].should eql("#{seed_limit}")
    end

    describe "#stat_over_time" do
      let(:meme) { Meme.first }
      subject { meme.stat_over_time }
      it "should only include stats for the given meme" do
        subject.collect(&:meme_name).uniq.should eql([meme.name])
      end
      it "should have the correct episode number" do
        subject.first[:number].should eql(show_number.to_s)
      end
      it "should have the correct note count" do
        subject.first[:note_count].should eql(meme.name)
      end
    end

  end

end