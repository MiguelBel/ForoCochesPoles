require "./app"
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'sidekiq' && password == 'sidekiq'
  end
  use Rack::Session::Cookie,  :secret=> "my_S3cR3T_M1ddL3WlW4r3_%&/(((/%$" 
  run Sidekiq::Web
end

run Sinatra::Application