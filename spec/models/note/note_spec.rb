require 'spec_helper'

describe Note do
  it_behaves_like "has a valid test factory", :note, Note

  it_behaves_like "having associations", Note, {
    :show             => :belongs_to,
    :meme             => :belongs_to
  }

  describe "#destroy" do
    let!(:meme) { Factory(:meme) }
    let!(:show) { Factory(:show) }
    let!(:note) { Factory(:note, :show => show, :meme => meme ) }
    subject { note.destroy }
    it "should not remove related shows" do
      expect { subject }.not_to change { Show.count }
    end
    it "should not remove related memes" do
      expect { subject }.not_to change { Meme.count }
    end
  end

  describe "##videos" do
    let!(:video_meme) { Factory(:meme, :name => 'VIDEO') }
    let!(:video_note) { Factory(:note, :meme => video_meme) }
    let!(:nonvideo_note) { Factory(:note) }
    subject { Note.videos }
    it { should include(video_note) }
    it { should_not include(nonvideo_note) }
  end
end
