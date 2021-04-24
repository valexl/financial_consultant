require './app'

unless ENV['RACK_ENV'] == 'development'
  # # it's suggested to use .freeze for non development environment
  # FinancialConsultant::Investments::App.freeze
end
run FinancialConsultant::Investments::App.app
