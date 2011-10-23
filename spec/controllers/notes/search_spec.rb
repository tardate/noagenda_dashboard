require 'spec_helper'

describe NotesController do
  render_views
  let!(:found_name) { 'namefound' }
  let!(:found_description) { 'descriptionfound' }
  let!(:found_meme) { 'memefound' }
  let!(:show) { Factory(:show) }
  let!(:meme) { Factory(:meme, :name => found_meme ) }
  let!(:unfound_meme) { Factory(:meme) }
  
  let!(:note_by_name) { Factory(:note, :show => show, :name => found_name) }
  let!(:note_by_desc) { Factory(:note, :show => show, :description => found_description) }
  let!(:note_by_meme) { Factory(:note, :show => show, :meme => meme) }
  let!(:unfound_note) { Factory(:note, :show => show, :meme => unfound_meme) }
  
  describe "search" do
    subject { xhr :get, :index, "search" => { "name_or_description_or_meme_name_contains" => search_term } }

    context "find by note.name" do
      let(:search_term) { found_name }
      it { should be_success }
      its(:body) { should include(note_by_name.name) }
      its(:body) { should_not include(note_by_desc.name) }
      its(:body) { should_not include(note_by_meme.name) }
      its(:body) { should_not include(unfound_note.name) }
    end

    context "find by note.description" do
      let(:search_term) { found_description }
      it { should be_success }
      its(:body) { should_not include(note_by_name.name) }
      its(:body) { should include(note_by_desc.name) }
      its(:body) { should_not include(note_by_meme.name) }
      its(:body) { should_not include(unfound_note.name) }
    end

    context "find by meme.name" do
      let(:search_term) { found_meme }
      it { should be_success }
      its(:body) { should_not include(note_by_name.name) }
      its(:body) { should_not include(note_by_desc.name) }
      its(:body) { should include(note_by_meme.name) }
      its(:body) { should_not include(unfound_note.name) }
    end

  end
end