require 'spec_helper'

describe "notes/new.html.erb" do
  before(:each) do
    assign(:note, stub_model(Note,
      :name => "MyString",
      :url => "MyString"
    ).as_new_record)
  end

  it "renders new note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path, :method => "post" do
      assert_select "input#note_name", :name => "note[name]"
      assert_select "input#note_url", :name => "note[url]"
    end
  end
end
