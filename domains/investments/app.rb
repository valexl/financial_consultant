require 'roda'
require 'logger'
require 'dotenv'

ENV['RACK_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

require_relative 'db'

module FinancialConsultant
  module Investments
    class App < Roda
      use Rack::CommonLogger, Logger.new($stdout)

      plugin :all_verbs
      plugin :render, escape: true
      plugin :render_each
      plugin :partials

      route do |r|
        r.root do
          view 'home'
        end
      end
    end
  end
end
