require 'spec_helper'

describe Show do
  let(:seed_limit) { 10 }

  describe "##meme_stats" do
    subject { Show.meme_stats }
    let!(:show) { Factory.create(:show) }
    let!(:other_show) { Factory.create(:show) }
    before {
      (1..seed_limit).each do |i|
        m = Factory.create(:meme, :name => i.to_s )
        i.times {
          Factory.create(:note, :meme => m, :show => show)
          Factory.create(:note, :meme => m, :show => other_show)
        }
      end
    }
    it { subject.to_a.count.should eql(seed_limit) }
    it "should count notes correctly" do
      subject.first[:meme_name].should eql("1")
      subject.first[:note_count].should eql("2")
      subject.last[:meme_name].should eql("#{seed_limit}")
      subject.last[:note_count].should eql("#{seed_limit * 2}")
    end

    describe "#meme_stat" do
      subject { show.meme_stat }
      it { subject.to_a.count.should eql(seed_limit) }
      it "should have the correct note count" do
        subject.each do |stat|
          stat[:note_count].should eql(stat[:meme_name])
        end
      end
    end

  end

end