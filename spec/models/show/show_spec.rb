require 'spec_helper'

describe Show do
  it_behaves_like "has a valid test factory", :show, Show

  describe "##latest" do
    let!(:show_a) { Factory(:show, :published_date => 1.day.ago) }
    let!(:show_b) { Factory(:show, :published_date => 2.days.ago) }
    subject { Show.latest }
    it { should eql(show_a) }
  end
end
