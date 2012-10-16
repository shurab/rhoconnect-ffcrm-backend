#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path(File.dirname(__FILE__))

if ENV['DEBUG'] == 'yes'
  ENV['APP_TYPE'] = 'rhosync'
  ENV['ROOT_PATH'] = ROOT_PATH
  require 'debugger'
end

require 'rhoconnect/server'
require 'rhoconnect/web-console/server'
require 'resque/server'

# Rhoconnect server flags
#Rhoconnect::Server.enable  :stats
Rhoconnect::Server.disable :run
Rhoconnect::Server.disable :clean_trace
Rhoconnect::Server.enable  :raise_errors
Rhoconnect::Server.set     :secret,      'fa85d2780d3670ba6650256aea272aa7fc370d6247ce82b5c9607c53e9e2a6c52c0e248773c3d71e888e4f5decda6961b08265e9d161c8368f16de85da0abe09'
Rhoconnect::Server.set     :root,        ROOT_PATH
Rhoconnect::Server.use     Rack::Static, :urls => ['/data'], :root => Rhoconnect::Server.root
# disable Async mode if Debugger is used
if ENV['DEBUG'] == 'yes'
  Rhoconnect::Server.set :use_async_model, false
end

# Disable ruby's buffering to stdout
$stdout.sync = true
puts "Starting ffcrm-server ..."

# Load our rhoconnect application
require './application'

# Setup the url map
run Rack::URLMap.new \
	'/'         => Rhoconnect::Server.new,
	'/resque'   => Resque::Server.new, # If you don't want resque frontend, disable it here
	'/console'  => RhoconnectConsole::Server.new # If you don't want rhoconnect frontend, disable it here
	