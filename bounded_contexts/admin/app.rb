require 'dotenv'
require 'logger'
require_relative '../common/common'

ENV['RACK_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

ENV["BUNDLE_GEMFILE"] = Dir.pwd + "/Gemfile"

Dir[File.dirname(__FILE__) + '/config/initializers/*.rb'].each {|file| require file }

