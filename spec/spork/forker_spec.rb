require File.dirname(__FILE__) + '/../spec_helper'

describe Spork::Forker do
  it "runs a block in a fork" do
    @var = "hello world"
    Spork::Forker.new { @var = "booyah" }.result
    @var.should == "hello world"
  end
  
  it "returns the result" do
    Spork::Forker.new { "results" }.result.should == "results"
  end
  
  it "reports when the fork is running" do
    forker = Spork::Forker.new { sleep 0.1 }
    forker.running?.should == true
    forker.result
    sleep 0.1
    forker.running?.should == false
  end
  
  it "aborts a fork and returns nil for the result" do
    started_at = Time.now
    ended_at = nil
    forker = Spork::Forker.new { sleep 5 }
    Thread.new do
      forker.result.should == nil
      ended_at = Time.now
    end
    sleep 0.5
    forker.abort
    sleep 0.1
    (ended_at - started_at).should be_close(0.5, 0.1)
    forker.running?.should == false
  end
end
