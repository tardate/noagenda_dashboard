require 'spec_helper'

describe Meme do
  let!(:show) { Factory(:show) }
  let!(:from_meme) { Factory(:meme) }
  let!(:from_meme_name) { from_meme.name }
  let!(:to_meme) { Factory(:meme) }
  let!(:to_meme_name) { to_meme.name }
  let!(:from_note_a) { Factory(:note, :meme => from_meme, :show => show) }
  let!(:from_note_b) { Factory(:note, :meme => from_meme, :show => show) }
  let!(:from_note_c) { Factory(:note, :meme => from_meme, :show => show) }
  let!(:to_note_a) { Factory(:note, :meme => to_meme, :show => show) }

  describe "##merge" do
    context "with valid transfer" do
      before { Meme.merge(from_meme_name,to_meme_name) }
      describe "from_meme" do
        subject { Meme.find_by_name(from_meme_name) }
        it { should be_nil }
      end
      describe "notes" do
        subject { to_meme.notes }
        its(:count) { should eql(4) }
      end
    end
    context "with new meme" do
      let(:new_meme_name) { 'new meme name' }
      let(:new_meme) { Meme.find_by_name(new_meme_name) }
      before { Meme.merge(from_meme_name,new_meme_name) }
      describe "from_meme" do
        subject { Meme.find_by_name(from_meme_name) }
        it { should be_nil }
      end
      describe "to_meme" do
        subject { new_meme }
        it { should be_a(Meme) }
        describe "notes" do
          subject { new_meme.notes }
          its(:count) { should eql(3) }
        end
      end
    end
  end

end