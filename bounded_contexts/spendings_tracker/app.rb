require 'dotenv'
require 'logger'

ENV['RACK_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['RACK_ENV']}")



require_relative 'config/db'
require_relative '../common/common'
require_relative 'config/domain'
require_relative 'config/port'
require_relative 'config/application'
