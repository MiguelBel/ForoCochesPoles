require "pp"
require "curb"
require "nokogiri"
require "rspec"

require_relative '../lib/forocoches_api/thread_petitions'
require_relative '../lib/forocoches_tracker/database'
require_relative '../lib/forocoches_tracker/tracker'

require 'forocoches_api/url_constructor'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end