require "pp"
require "curb"
require "nokogiri"
require "rspec"
require 'vcr'
require 'webmock/rspec'
require 'active_record'

require 'forocoches_tracker/tracker'

require 'forocoches_api/url_constructor'
require 'forocoches_api/thread_petitions'

require_relative '../db/poles'

connection_info = YAML.load_file("db/config.yml")["test"]
ActiveRecord::Base.establish_connection(connection_info)

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  ActiveRecord::Base.transaction do
    raise ActiveRecord::Rollback
  end
end

VCR.configure do |config|
  config.cassette_library_dir     = 'spec/fixtures/cassettes'
  config.hook_into                :webmock
  config.default_cassette_options = { :record => :new_episodes }
end

def disableVCRandWebMock
  WebMock.allow_net_connect!
  VCR.turn_off!
end
