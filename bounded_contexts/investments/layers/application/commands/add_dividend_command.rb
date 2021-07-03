module Commands
  class AddDividendCommand < BaseCommand

    def initialize(investment_name:, dividend_currency:, dividend_value: )
      @investment_name = investment_name
      @dividend_currency = dividend_currency
      @dividend_value = dividend_value.to_f
    end

    def execute(balance)
      return unless investment = balance.find_investment(name: @investment_name)
      dividend = ::Investments::Dividend.new(currency: @dividend_currency, value: @dividend_value)
      investment.add_dividend(dividend)
      investment
    end
  end
end