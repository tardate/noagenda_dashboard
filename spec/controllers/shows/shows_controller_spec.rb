require 'spec_helper'

describe ShowsController do
  render_views
  let(:resource) { Factory(:show) }

  describe "GET index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET show" do
    subject { get :show, :id => resource.number }
    it { should be_success }
  end

  describe "XHR GET show" do
    subject { xhr :get, :show, :id => resource.number }
    it { should be_success }
  end

end
