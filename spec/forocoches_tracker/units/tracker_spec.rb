require 'spec_helper'

describe "Tracker" do

  context "Initialize the tracker" do
    it "Check the default quantity of tracking" do
      default = 100
      tracker = ForoCochesTracker::Database.new
      expect(tracker.number_of_petitions).to eq(default)
    end

    it "Check a custom quantity of tracking" do
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      expect(tracker.number_of_petitions).to eq(custom)      
    end

    it "Get the initial thread for start to track" do
      tracker = ForoCochesTracker::Database.new
      initial_thread = tracker.getInitialThread
      expect(tracker.initial_thread).to eq(initial_thread)
    end
  end

  context "Start the tracker" do
    it "Track and check the inserts in the database" do
      disableVCRandWebMock
      initial_poles_count = Poles.count
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      tracker.track
      final_poles_count = Poles.count
      expect(final_poles_count).to eq(initial_poles_count + custom)
    end
  end
end