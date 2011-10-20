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
    let!(:show) { Factory.create(:show, :number => 33 ) }
    before {
      (1..20).each do |i|
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
    it "should have 10 series values sets" do
      subject[:values].count.should eql(10)
    end
    it "should have 10 series legends" do
      subject[:legend].count.should eql(10)
    end
    it "should have the correct 5th data series (for example)" do
      subject[:values][:"serie5"].should eql([15])
      subject[:legend][:"serie5"].should eql("meme-15")
    end
  end

end