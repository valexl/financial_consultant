require 'roda'
require 'logger'
require 'dotenv'

ENV['RACK_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

unless ENV['RACK_ENV'] == 'production'
  require 'byebug'
end

require_relative 'db'
require_relative 'api'
require_relative 'domain'

module FinancialConsultant
  module Investments
    class App < Roda
      use Rack::CommonLogger, Logger.new($stdout)

      plugin :all_verbs
      plugin :render, escape: true, views: 'templates', layout: './layout'
      plugin :render_each
      plugin :partials
      plugin :view_options

      route do |r|
        r.on "api" do
          r.run API
        end

        r.root do
          r.redirect '/balance/'
        end

        r.on 'balance' do
          set_view_subdir 'balance'
          r.root do
            view 'show'
          end

          r.on 'replenish' do
            r.get do
              view 'replenish'
            end

            r.post do
              r.redirect '/balance/'
            end
          end
        end

        r.on 'investments' do
          set_view_subdir 'investments'

          r.on 'open' do
            r.get do
              view 'open'
            end

            r.post do
              r.redirect '/balance/'
            end
          end

          r.on Integer do |_investment_id|
            r.put do
              r.redirect '/balance/'
            end

            r.get 'edit' do
              view 'edit'
            end

            r.get 'close' do
              view 'close'
            end

            r.put 'close' do
              r.redirect '/balance/'
            end
          end
        end
      end
    end
  end
end
