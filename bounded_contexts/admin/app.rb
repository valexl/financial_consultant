require 'dotenv'
require 'logger'

ENV['RACK_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

ENV["BUNDLE_GEMFILE"] = Dir.pwd + "/Gemfile"
require_relative '../common/common'

Dir[File.dirname(__FILE__) + '/config/initializers/*.rb'].each {|file| require file }

