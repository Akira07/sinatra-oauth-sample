require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'omniauth'
require 'omniauth-github'
require 'json'
require 'rest-client'
require 'dotenv'
Dotenv.load
require './lib/github_session'

use OmniAuth::Builder do
  provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET']
end

before do
  pass if session[:gh_uid]
  pass if request.path_info =~ %r(^/login$)
  pass if request.path_info =~ %r(^/auth/github/callback$)
  redirect("/login?callback=#{request.path_info}")
end

get '/' do
  'Top'
end

get '/sample' do
  'Sample'
end

get 'test' do
  'Test'
end

get '/login' do
  cookies[:callback] = params[:callback]
  <<-HTML
  <a href='/auth/github'>Sign in with GitHub</a>
  HTML
end

get '/auth/github/callback' do
  auth = request.env['omniauth.auth']
  gh_id = auth.info.nickname
  unless Zackylab.members?(gh_id)
    redirect(not_found)
    return
  end
  session[:gh_uid] = auth.uid
  callback = cookies[:callback] || '/'
  redirect(callback)
end

get '/logout' do
  session.clear
  <<-HTML
  <p>Logoutしました</p>
  
  <a href="/">Topへ</a>
  HTML
end

not_found do
  'Not Found'
end
