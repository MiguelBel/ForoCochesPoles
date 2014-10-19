require 'daemons'
require "pp"
require "curb"
require "nokogiri"

require_relative 'lib/forocoches_api/url_constructor'
require_relative 'lib/forocoches_api/thread_petitions'
require_relative 'lib/forocoches_tracker/database'
require_relative 'lib/forocoches_tracker/tracker'

Process.daemon(true)

loop do
  pid = Process.fork do
    last_id = Poles.last.id_thread
    ((last_id + 1)..(last_id + 11)).each_with_index do |thread_id, index|
      thread = FCThread.new(thread_id)
      tracker = Tracker.new
      break if thread.getStatusOfThread != 2
      tracker.insertInDatabase(thread) 
    end
  end

  Process.waitpid(pid)

  # Reduce CPU usage
  sleep(20)
end
