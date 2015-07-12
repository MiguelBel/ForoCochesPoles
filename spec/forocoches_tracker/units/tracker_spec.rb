require 'spec_helper'

describe ForoCochesTracker::Database do

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

  context "Individual tracker" do
    it "When called the individualTrack it calls to the individualPetitions" do
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      expect(tracker).to receive(:doTheIndividualPetitions)
      tracker.individualTrack
    end

    it "When called the doTheIndividualPetitions it calls the petition manager" do
      disableVCRandWebMock
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      custom.times do |time|
        expect(ForoCochesAPI::PetitionManager).to receive(:new)
        expect(tracker).to receive(:insertInDatabase)
      end
      tracker.individualTrack
    end
  end

  context "Bulk tracker" do
    it "When the bulk track is called it calls the function which create empty records and the one which fill those empty records" do
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      expect(tracker).to receive(:createEmptyRecords)
      expect(tracker).to receive(:fillEmptyRecords)
      tracker.bulkTrack
    end

    it "When the createEmptyRecords function is called it calls the custom number of single empty record create" do
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      custom.times do |time|
        expect(tracker).to receive(:createEmptyRecord)
      end
      tracker.createEmptyRecords
    end

    it "When the fillEmptyRecords function is called it calls the custom number of single empty record create" do
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      custom.times do |time|
        expect(tracker).to receive(:fillEmptyRecord)
      end
      tracker.fillEmptyRecords
    end
  end
end