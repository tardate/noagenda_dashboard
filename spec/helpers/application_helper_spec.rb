require 'spec_helper'

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

  [:dedouche_links, :bok_links].each do |link_collection|
    describe "##{link_collection}" do
      subject { helper.send(link_collection) }
      it { should be_a(Array) }
      context "elements" do
        it "should be a hash with :url and :name" do
          subject.each do |el|
            el.should be_a(Hash)
            el[:url].present?.should be_true
            el[:name].present?.should be_true
          end
        end
      end
    end
  end

end
