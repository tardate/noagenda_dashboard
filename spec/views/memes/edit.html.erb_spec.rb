require 'spec_helper'

describe "memes/edit.html.erb" do
  before(:each) do
    @meme = assign(:meme, stub_model(Meme,
      :name => "MyString"
    ))
  end

  it "renders the edit meme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => memes_path(@meme), :method => "post" do
      assert_select "input#meme_name", :name => "meme[name]"
    end
  end
end
