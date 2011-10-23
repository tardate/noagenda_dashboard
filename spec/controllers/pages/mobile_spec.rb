require 'spec_helper'

describe PagesController do
  render_views
  before do
    Browser.any_instance.stub(:iphone?).and_return(true)
  end

  [:technoexperts].each do |page|
    describe page do
      describe "GET" do
        subject { get page }
        it { should be_success }
      end
      describe "XHR GET" do
        subject { xhr :get, page }
        it { should be_success }
      end
    end
  end

end