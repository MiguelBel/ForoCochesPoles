require 'daemons'
require "pp"
require "curb"
require "nokogiri"

require_relative 'lib/forocoches_api/url_constructor'
require_relative 'lib/forocoches_api/thread_petitions'
require_relative 'lib/forocoches_tracker/database'
require_relative 'lib/forocoches_tracker/tracker'

loop do
  tracker = Tracker.new(50)
  tracker.doThePetitions
end