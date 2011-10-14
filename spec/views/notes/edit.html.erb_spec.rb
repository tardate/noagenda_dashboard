require 'spec_helper'

describe "notes/edit.html.erb" do
  before(:each) do
    @note = assign(:note, stub_model(Note,
      :name => "MyString",
      :url => "MyString"
    ))
  end

  it "renders the edit note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path(@note), :method => "post" do
      assert_select "input#note_name", :name => "note[name]"
      assert_select "input#note_url", :name => "note[url]"
    end
  end
end
