require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

map '/' do
  use Rack::SSL
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  run Sidekiq::Web
end
