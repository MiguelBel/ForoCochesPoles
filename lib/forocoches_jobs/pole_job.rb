require_relative 'jobs_helper'

class PolesJob
  include Sidekiq::Worker

  def perform(number_of_poles, job_number, delay)
    time_to_wait = job_number * delay
    p "Performing poles after #{time_to_wait} seconds"
    sleep time_to_wait
    processor = ForoCochesTracker::Database.new(number_of_poles)  
    processor.bulkTrack
  end
end
