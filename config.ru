require "rubygems"
require "bundler/setup"
require "sinatra"
require "haml"

require "./app.rb"
 
set :run, false
set :raise_errors, true
 
run App