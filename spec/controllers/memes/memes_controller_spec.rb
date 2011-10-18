require 'spec_helper'

describe MemesController do
  render_views
  let(:resource) { Factory(:meme) }

  describe "GET :index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET :show" do
    subject { get :show, :id => resource.id }
    it { should be_success }
  end

  describe "XHR GET :show" do
    subject { xhr :get, :show, :id => resource.id }
    it { should be_success }
  end

end
