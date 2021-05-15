$browser = Rack::Test::Session.new(FinancialConsultant::Investments::App.app)
$money_creator = MoneyCreator.new(MoneyBuilder.new)
