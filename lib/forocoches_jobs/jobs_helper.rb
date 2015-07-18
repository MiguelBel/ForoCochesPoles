require "curb"
require "nokogiri"
require 'active_record'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'

require_relative '../forocoches_tracker/tracker'

require_relative '../forocoches_api/url_constructor'
require_relative '../forocoches_api/thread_petitions'

require_relative '../../db/poles'

connection_info = YAML.load_file("db/config.yml")["development"]
ActiveRecord::Base.establish_connection(connection_info)
