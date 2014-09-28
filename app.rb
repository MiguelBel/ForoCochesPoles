require "sinatra"
require "erb"

require_relative "lib/forocoches_web/controllers/user_interface_controllers"
require_relative "lib/forocoches_web/helpers/user_interface_helpers"
require_relative "lib/forocoches_tracker/database"

set :views, File.join(File.dirname(__FILE__), '/lib/forocoches_web/views')

get '/' do
  mainPageController
end