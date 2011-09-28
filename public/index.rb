#!/usr/local/bin/ruby -Ku
# coding: UTF-8

require '../config/include_path.rb'

require '../lib/willow.rb'

require './main.rb'

#app = Rack::Session::Cookie.new Rack::ShowExceptions.new WillowApp.new
app = WillowApp.new
#app = Rack::ShowExceptions.new(app)
app = Rack::Session::Memcache.new(app)
Rack::Handler::CGI.run app
