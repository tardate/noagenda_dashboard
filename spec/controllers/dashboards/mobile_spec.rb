require 'spec_helper'

describe DashboardsController do
  render_views
  before do
    Browser.any_instance.stub(:iphone?).and_return(true)
  end

  describe "GET show" do
    subject { get :show }
    it { should be_success }
  end

  describe "GET menu" do
    subject { get :menu }
    it { should be_success }
  end

end
