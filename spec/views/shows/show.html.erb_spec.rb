require 'spec_helper'

describe "shows/show.html.erb" do
  before(:each) do
    @show = assign(:show, stub_model(Show,
      :number => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
