require_relative 'pole_job'

total_poles_to_track = ARGV[0].to_i
jobs_size = ARGV[1].to_i
top_limit = ARGV[2].to_i
delay = ARGV[3].to_i
number_of_jobs = total_poles_to_track / jobs_size  

(1..number_of_jobs).each do |job_number|
  p "Added process ##{job_number} for #{jobs_size} jobs"
  PolesJob.perform_async(jobs_size, job_number, top_limit, delay)
end