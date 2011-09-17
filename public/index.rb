#!/usr/local/bin/ruby -Ku
# coding: UTF-8

require 'rubygems'
require 'rack'

require './main.rb'

#app = Rack::Session::Cookie.new Rack::ShowExceptions.new WillowApp.new
app = WillowApp.new
#app = Rack::ShowExceptions.new(app)
app = Rack::Session::Memcache.new(app)
Rack::Handler::CGI.run app
