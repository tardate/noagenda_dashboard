require 'spec_helper'

describe "device detection methods" do
  before do
    ApplicationController.any_instance.stub(:browser).and_return(Browser.new)
    Browser.any_instance.stub(:ios?).and_return(false)
    Browser.any_instance.stub(:iphone?).and_return(false)
    Browser.any_instance.stub(:ipad?).and_return(false)
    Browser.any_instance.stub(:android?).and_return(false)
  end

  [
    { :method => :mobile_device?, :ios? => true, :android? => true, :ipad? => true, :iphone? => true },
    { :method => :smartphone?, :ios? => false, :android? => true, :ipad? => false, :iphone? => true }
  ].each do |options|
    describe "##{options[:method]}" do
      subject { ApplicationController.new.send(options[:method]) }
      it { should be_false }
      context "when ios device" do
        before { Browser.any_instance.stub(:ios?).and_return(true) }
        it { should eql(options[:ios?]) }
      end
      context "when android device" do
        before { Browser.any_instance.stub(:android?).and_return(true) }
        it { should eql(options[:android?]) }
      end
      context "when ipad device" do
        before {
          Browser.any_instance.stub(:ios?).and_return(true)
          Browser.any_instance.stub(:ipad?).and_return(true)
        }
        it { should eql(options[:ipad?]) }
      end
      context "when iphone device" do
        before {
          Browser.any_instance.stub(:ios?).and_return(true)
          Browser.any_instance.stub(:iphone?).and_return(true)
        }
        it { should eql(options[:iphone?]) }
      end
    end
  end

end
