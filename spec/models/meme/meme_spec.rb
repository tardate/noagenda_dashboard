require 'spec_helper'

describe Meme do
  it_behaves_like "has a valid test factory", :meme, Meme

  it_behaves_like "having associations", Meme, {
    :notes             => :has_many,
    :shows             => :has_many
  }

  describe "##select_listing" do
    let!(:meme_a) { Factory(:meme, :name => 'aaa') }
    let!(:meme_b) { Factory(:meme, :name => 'bbb') }
    subject { Meme.select_listing }
    its(:first) { should eql(meme_a) }
    its(:last) { should eql(meme_b) }
  end

end
