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
     tracker = Tracker.new(25)
     tracker.doThePetitions
  end

  Process.waitpid(pid)

  # Reduce CPU usage
  sleep(5)
end
