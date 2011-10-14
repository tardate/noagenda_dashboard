require 'spec_helper'

describe "memes/new.html.erb" do
  before(:each) do
    assign(:meme, stub_model(Meme,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new meme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => memes_path, :method => "post" do
      assert_select "input#meme_name", :name => "meme[name]"
    end
  end
end
