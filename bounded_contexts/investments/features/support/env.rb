ENV['RACK_ENV'] = 'test'
require 'byebug'
require 'rack/test'
require File.expand_path('../../app', __dir__)
