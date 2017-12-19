require 'bundler/setup'
require './app'
require 'rack'
require "redis-store"
require 'rack/session/redis'

use Rack::Session::Redis, {
  :url          => "redis://127.0.0.1:6379/2",
  :namespace    => "rack:session",
  :expire_after => 600
}

run Sinatra::Application