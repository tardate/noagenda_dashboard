require 'spec_helper'

describe DashboardsController do
  render_views
  
  describe "GET show" do
    subject { get :show }
    it { should be_success }
  end

end
