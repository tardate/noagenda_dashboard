require 'spec_helper'

describe "memes/index.html.erb" do
  before(:each) do
    assign(:memes, [
      stub_model(Meme,
        :name => "Name"
      ),
      stub_model(Meme,
        :name => "Name"
      )
    ])
  end

  it "renders a list of memes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
