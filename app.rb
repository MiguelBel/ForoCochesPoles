# UTF-8
require "sinatra"
require "erb"
require "rufus-scheduler"
require "active_record"


# Files required
require_relative "lib/forocoches_web/controllers/user_interface_controllers"
require_relative "lib/forocoches_web/helpers/user_interface_helpers"

require_relative 'db/poles'

connection_info = YAML.load_file("db/config.yml")["test"]
ActiveRecord::Base.establish_connection(connection_info)

# Dir config
set :views, File.join(File.dirname(__FILE__), '/lib/forocoches_web/views')
set :public_dir, File.join(File.dirname(__FILE__), '/lib/forocoches_web/public')

# Cronjobs
scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
  globalRankingGenerator
  pp "doned"
end

# Routes
get '/' do
  mainPageController
end

post '/finder' do
  finderController
end

get '/faq' do
  erb :faq, :layout => :template
end

get '/force_global_ranking' do
  globalRankingGenerator
  "Forcing completed"
end

## Not alone
get '/finder' do
  erb :custom_error, :layout => :template, :locals => {:error => "Usa el campo de búsqueda, estamos \"trabajando\" en una API"}
end