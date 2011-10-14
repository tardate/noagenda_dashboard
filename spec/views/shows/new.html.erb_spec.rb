require 'spec_helper'

describe "shows/new.html.erb" do
  before(:each) do
    assign(:show, stub_model(Show,
      :code => 1
    ).as_new_record)
  end

  it "renders new show form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shows_path, :method => "post" do
      assert_select "input#show_code", :name => "show[code]"
    end
  end
end
