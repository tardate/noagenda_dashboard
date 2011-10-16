require 'spec_helper'

describe "shows/index.html.erb" do
  before(:each) do
    assign(:shows, [
      stub_model(Show,
        :number => 1
      ),
      stub_model(Show,
        :number => 1
      )
    ])
  end

  it "renders a list of shows" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
