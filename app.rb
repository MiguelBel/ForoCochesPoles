# UTF-8
require "sinatra"
require "erb"
require "rufus-scheduler"


# Files required
require_relative "lib/forocoches_web/controllers/user_interface_controllers"
require_relative "lib/forocoches_web/helpers/user_interface_helpers"
require_relative "lib/forocoches_tracker/database"

# Dir config
set :views, File.join(File.dirname(__FILE__), '/lib/forocoches_web/views')
set :public_dir, File.join(File.dirname(__FILE__), '/lib/forocoches_web/public')

# Cronjobs
scheduler = Rufus::Scheduler.new

scheduler.in '10m' do
  globalRankingGenerator
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

## Not alone
get '/finder' do
  erb :custom_error, :layout => :template, :locals => {:error => "Usa el campo de búsqueda, estamos \"trabajando\" en una API"}
end