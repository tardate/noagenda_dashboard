require 'spec_helper'

describe "memes/show.html.erb" do
  before(:each) do
    @meme = assign(:meme, stub_model(Meme,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
