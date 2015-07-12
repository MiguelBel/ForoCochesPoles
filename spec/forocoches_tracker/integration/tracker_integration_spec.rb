require 'spec_helper'

describe ForoCochesTracker::Database do
  context "Individual tracker" do
    it "Track and check the inserts in the database" do
      disableVCRandWebMock
      initial_poles_count = Poles.count
      custom = 10
      tracker = ForoCochesTracker::Database.new(custom)
      tracker.individualTrack
      final_poles_count = Poles.count
      expect(final_poles_count).to eq(initial_poles_count + custom)
    end
  end

  context "Bulk tracker do" do
    it "on initialize creates the number asked of empty records" do
      custom = 10
      initial_pending_poles_count = Poles.where("status = ?", "pending").count
      tracker = ForoCochesTracker::Database.new(custom)
      tracker.createEmptyRecords
      final_pending_poles_count = Poles.where("status = ?", "pending").count
      expect(final_pending_poles_count).to eq (initial_pending_poles_count + custom)
    end

    it "on initialize creates the number asked of empty records and fill with right data" do
      disableVCRandWebMock
      custom = 10
      initial_pending_poles_count = Poles.where("status = ?", "pending").count
      initial_total_poles_count = Poles.all.count
      tracker = ForoCochesTracker::Database.new(custom)
      tracker.bulkTrack
      final_pending_poles_count = Poles.where("status = ?", "pending").count
      final_total_poles_count = Poles.all.count
      expect(final_pending_poles_count).to eq (initial_pending_poles_count)
      expect(final_total_poles_count).to eq (initial_total_poles_count + 10)
    end
  end
end
