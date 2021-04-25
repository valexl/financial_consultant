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
      plugin :render, escape: true, views: "templates", layout: './layout'
      plugin :render_each
      plugin :partials
      plugin :view_options

      route do |r|
        r.root do
          r.redirect "/balance"
        end

        r.on "balance" do
          set_view_subdir "balance"
          r.root do
            view "show"
          end

          r.get "replenish" do
            view "replenish"
          end
        end

        r.on "investments" do
          set_view_subdir "investments"

          r.get "open" do
            view "open"
          end

          r.on Integer do |investment_id|
            r.get "edit" do
              view "edit"
            end

            r.get "close" do
              view "close"
            end
          end
        end
      end
    end
  end
end
