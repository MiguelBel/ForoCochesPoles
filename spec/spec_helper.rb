require "pp"
require "curb"
require "nokogiri"
require "rspec"
require 'vcr'
require 'webmock/rspec'

require_relative '../lib/forocoches_tracker/database'
require_relative '../lib/forocoches_tracker/tracker'

require 'forocoches_api/url_constructor'
require 'forocoches_api/thread_petitions'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

VCR.configure do |config|
  config.cassette_library_dir     = 'spec/fixtures/cassettes'
  config.hook_into                :webmock
  config.default_cassette_options = { :record => :new_episodes }
end

