require 'spec_helper'

describe "shows/edit.html.erb" do
  before(:each) do
    @show = assign(:show, stub_model(Show,
      :code => 1
    ))
  end

  it "renders the edit show form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shows_path(@show), :method => "post" do
      assert_select "input#show_code", :name => "show[code]"
    end
  end
end
