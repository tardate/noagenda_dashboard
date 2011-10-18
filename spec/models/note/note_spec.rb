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
end
