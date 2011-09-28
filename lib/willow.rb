$: << File.join(File.dirname(__FILE__), "willow")

require 'rubygems'
require 'rack'
require 'kconv'
require 'find'
require 'securerandom'
require 'cgi'

require 'rack/request'
require 'rack/response'
require 'digest/sha2'

gem 'mysql'
require 'mysql'

gem 'captcha'
require 'captcha'

require "const.rb"
require "convert_jp_num.rb"
require "gen_sid.rb"
require "page_base.rb"
require "template.rb"
require "util.rb"
require "db/db_accessor.rb"
require "db/db_result.rb"
require "db/dataobject.rb"
require "db/user.rb"
require "db/willow.rb"
require "db/follow.rb"
