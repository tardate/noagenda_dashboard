require 'spec_helper'

class ChartableInController < ActionController::Base
  include Navd::Chartable
end

describe "Chartable" do
  subject { ChartableInController.new }

  [:to_chartable_structure].each do |method|
    describe method do
      it "should be available as a class and instance method" do
        subject.should respond_to(method)
        subject.class.should respond_to(method)
      end
    end
  end

  describe "#to_chartable_structure" do
    let(:meme_limit) { AppConstants.number_of_trending_memes || 10 }
    let(:seed_limit) { meme_limit + 10 }
    let(:first_top_meme) { seed_limit - meme_limit + 1 }

    let!(:show) { Factory.create(:show, :number => 33 ) }
    before {
      (1..seed_limit).each do |i|
        m = Factory.create(:meme, :name => "meme-#{i}" )
        i.times { Factory.create(:note, :meme => m, :show => show) }
      end
    }
    let(:chart_def) {
      {
        template: 'line_basic',
        ylabels: { :column => 'meme_name'},
        yvalues: { :column => 'note_count'},
        xlabels: { :column => 'number'}
      }
    }
    subject { ChartableInController.new.to_chartable_structure(Meme.stats_over_time,chart_def) }
    it { should be_a(Hash) }
    it "should have 1 show (x axis)" do
      subject[:labels].count.should eql(1)
    end
    it "should have required number of series values sets" do
      subject[:values].count.should eql(meme_limit)
    end
    it "should have required number of series legends" do
      subject[:legend].count.should eql(meme_limit)
    end
    it "should have the correct 1st data series (for example)" do
      subject[:values][:"serie1"].should eql([first_top_meme])
      subject[:legend][:"serie1"].should eql("meme-#{first_top_meme}")
    end
  end

end