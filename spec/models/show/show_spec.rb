require 'spec_helper'

describe Show do
  let(:published_date) { "2011-11-09" }
  let(:resource) { Factory(:show, :number => 33, :published_date => Date.parse(published_date) ) }

  it_behaves_like "has a valid test factory", :show, Show

  it_behaves_like "having associations", Show, {
    :notes             => :has_many,
    :memes             => :has_many
  }

  describe "#memes" do
    let!(:meme) { Factory(:meme) }
    before { 3.times { Factory.create(:note, :show => resource, :meme => meme)} }
    subject { resource.memes }
    its(:count) { should eql(1) }
    it { should include(meme) }
  end

  describe "##latest" do
    let!(:show_a) { Factory(:show, :number => 33, :published_date => 1.day.ago) }
    let!(:show_b) { Factory(:show, :number => 3, :published_date => 2.days.ago) }
    subject { Show.latest }
    it { should eql(show_a) }
  end

  describe "##select_listing" do
    let!(:show_a) { Factory(:show, :number => 3, :published => true ) }
    let!(:show_b) { Factory(:show, :number => 33, :published => true ) }
    let!(:show_c) { Factory(:show, :number => 333, :published => false ) }
    subject { Show.select_listing }
    its(:first) { should eql(show_b) }
    its(:last) { should eql(show_a) }
    it { should_not include(show_c) }
  end

  describe "##lastn_arel" do
    let(:limit) { AppConstants.number_of_shows_for_trending }
    before do
      (limit * 2).times { Factory.create(:show) }
    end
    subject { Show.where(:id => Show.lastn_arel(limit)) }
    its(:count) { should eql(limit) }
  end

  describe "##shows_for_trending_history_arel" do
    let(:limit) { AppConstants.number_of_shows_for_trending_history }
    before do
      (limit * 2).times { Factory.create(:show) }
    end
    subject { Show.where(:id => Show.shows_for_trending_history_arel) }
    its(:count) { should eql(limit) }
  end

  describe "#short_title" do
    let(:expected) { "33 - #{published_date}" }
    subject { resource }
    its(:short_title) { should eql(expected) }
  end

  describe "#short_id" do
    let(:expected) { "NA33" }
    subject { resource }
    its(:short_id) { should eql(expected) }
  end

  describe "#full_title" do
    let(:expected) { "33 - #{published_date} #{resource.name}" }
    subject { resource }
    its(:full_title) { should eql(expected) }
  end

  describe "#to_param" do
    let(:expected) { "33" }
    subject { resource }
    its(:to_param) { should eql(expected) }
  end

  describe '##next_number_to_load' do
    let(:first_show_number) { AppConstants.earliest_show_to_load }
    subject { Show.next_number_to_load }
    it "should start from AppConstants.earliest_show_to_load" do
      should eql(first_show_number)
    end
    context "with shows already loaded" do
      before { resource }
      it "should be the next show number in the sequence" do
        should eql(resource.number + 1)
      end
    end
  end

  describe "#twitter_publish_message" do
    let(:expected) { "#NoAgenda show ##{resource.number} attack vectors now at http://noagendadashboard.com" }
    subject { resource.twitter_publish_message }
    it { should eql(expected) }
  end

  describe "#destroy" do
    let!(:meme) { Factory(:meme) }
    let!(:show) { Factory(:show) }
    let!(:note) { Factory(:note, :show => show, :meme => meme ) }
    subject { show.destroy }
    it "should remove all show notes" do
      expect { subject }.to change { Note.count }.from(1).to(0)
    end
    it "should not remove all related memes" do
      expect { subject }.not_to change { Meme.count }
    end
  end

  describe "#videos" do
    let!(:video_meme) { Factory(:meme, :name => 'VIDEO') }
    let!(:video_note) { Factory(:note, :show => resource, :meme => video_meme) }
    let!(:nonvideo_note) { Factory(:note, :show => resource) }
    subject { resource.videos }
    it { should include(video_note) }
    it { should_not include(nonvideo_note) }
  end
end
