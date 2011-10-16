require 'spec_helper'

describe NotesController do
  render_views
  let(:resource) { Factory(:note) }

  describe "GET index" do
    subject { get :index }
    it { should be_success }
  end

  describe "GET show" do
    subject { get :show, :id => resource.id }
    it { should be_success }
  end
end
