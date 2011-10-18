require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe "#embed_media_player" do
    let(:mp3_link) { 'http://example.com/33.mp3'}
    subject { helper.embed_media_player(mp3_link) }
    it "should return embed code" do
      should include('embed')
    end
    it "should be html_safe" do
      subject.html_safe?.should be_true
    end
    context "with nil audio link" do
      subject { helper.embed_media_player(nil) }
      it { should be_nil }
    end
  end
end
